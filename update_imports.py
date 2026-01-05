import os
import re

package_name = 'TourEase'

replacements = {
    'package:TourEase/presentation/authentication/': 'package:TourEase/views/auth/',
    'package:TourEase/presentation/main_screen/': 'package:TourEase/views/home/',
    'package:TourEase/presentation/onboarding/': 'package:TourEase/views/onboarding/',
    'package:TourEase/presentation/widgets/': 'package:TourEase/core/widgets/',
    'package:TourEase/data/models/': 'package:TourEase/models/',
    'package:TourEase/view-model/': 'package:TourEase/viewmodels/',
    'package:TourEase/app/app.dart': 'package:TourEase/app.dart',
    'package:TourEase/app/routes/': 'package:TourEase/routes/',
    'package:TourEase/app/app_theme.dart': 'package:TourEase/core/app_theme.dart',
    'package:TourEase/app/app_bar_theme.dart': 'package:TourEase/core/app_bar_theme.dart',
    'package:TourEase/data/local/': 'package:TourEase/data/datasources/local/',
    'package:TourEase/data/datasources/local.dart': 'package:TourEase/data/datasources/local/local_storage_service.dart',
}

# Regex to find relative imports or imports that were moved but used as relative/partially absolute
import_pattern = re.compile(r"import\s+['\"](.+?)['\"]")

def resolve_import(current_file_dir, match):
    uri = match.group(1)
    if uri.startswith('package:') or uri.startswith('dart:') or 'plugins' in uri:
        return None  # Already package or system import

    # Common broken patterns from analysis:
    res = uri
    if 'presentation/authentication/' in res:
        res = res.replace('presentation/authentication/', 'views/auth/')
    if 'presentation/main_screen/' in res:
        res = res.replace('presentation/main_screen/', 'views/home/')
    if 'presentation/onboarding/' in res:
        res = res.replace('presentation/onboarding/', 'views/onboarding/')
    if 'presentation/widgets/' in res:
        res = res.replace('presentation/widgets/', 'core/widgets/')
    if 'data/models/' in res:
        res = res.replace('data/models/', 'models/')
    if 'view-model/' in res:
        res = res.replace('view-model/', 'viewmodels/')
    if res == 'app/app.dart' or res.endswith('/app/app.dart'):
        res = 'app.dart'
    if 'app/routes/' in res:
        res = res.replace('app/routes/', 'routes/')

    if res != uri:
        return res

    # Handle relative imports like ../../data/models/hills_model.dart
    if uri.startswith('../') or uri.startswith('./'):
        # Just resolve the directory if possible, or convert to package import if it contains key keywords
        if 'models/' in uri: return uri.replace('../../data/models/', 'package:TourEase/models/').replace('../data/models/', 'package:TourEase/models/')
        if 'widgets/' in uri: return uri.replace('../../presentation/widgets/', 'package:TourEase/core/widgets/').replace('../widgets/', 'package:TourEase/core/widgets/')
        if 'main_screen.dart' in uri: return f'package:{package_name}/views/home/main_screen.dart'
        if 'login_screen.dart' in uri: return f'package:{package_name}/views/auth/login/login_screen.dart'
        if 'home_screen.dart' in uri: return f'package:{package_name}/views/home/home/home_screen.dart'
        if 'verify_email.dart' in uri: return f'package:{package_name}/views/auth/verify_email.dart'
        if 'home_auth_screen.dart' in uri: return f'package:{package_name}/views/auth/home_auth_screen.dart'

    return None

def update_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    new_content = content
    # First apply hardcoded replacements
    for old, new in replacements.items():
        new_content = new_content.replace(old, new)

    # Then try to fix broken relative looking imports
    lines = new_content.split('\n')
    updated_lines = []
    for line in lines:
        if line.strip().startswith('import'):
            match = import_pattern.search(line)
            if match:
                resolved = resolve_import(os.path.dirname(filepath), match)
                if resolved:
                    if resolved.startswith('package:'):
                        line = re.sub(r"['\"].+?['\"]", f"'{resolved}'", line)
                    else:
                        # Clean it up and make it package import
                        clean_path = resolved.lstrip('./').replace('../', '')
                        if any(clean_path.startswith(prefix) for prefix in ['views', 'models', 'viewmodels', 'routes', 'core', 'data', 'app.dart']):
                             line = re.sub(r"['\"].+?['\"]", f"'package:{package_name}/{clean_path}'", line)
        updated_lines.append(line)

    new_content = '\n'.join(updated_lines)

    if new_content != content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)
        print(f"Updated: {filepath}")

def main():
    for root, dirs, files in os.walk('lib'):
        for file in files:
            if file.endswith('.dart'):
                update_file(os.path.join(root, file))

if __name__ == "__main__":
    main()
