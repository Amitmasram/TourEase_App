class Location {
  final String name;
  final String locality;
  final String image;
  final String about;
  final List<String> features;

  Location({
    required this.name,
    required this.locality,
    required this.image,
    required this.about,
    required this.features,
  });
}

final List<Location> locations = [
  Location(
    name: 'Umred Karhandla Wildlife Sanctuary',
    locality: 'Nagpur, Maharashtra',
    image: 'https://i.ytimg.com/vi/LIn2c4npTHA/maxresdefault.jpg',
    about:
        'A wildlife sanctuary famous for its tigers, leopards, and diverse flora and fauna.',
    features: ['Tiger Safari', 'Endangered species', 'Lush greenery'],
  ),
  Location(
    name: 'Futala Lake',
    locality: 'Nagpur, Maharashtra',
    image:
        'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/0a/a9/92/cd/clean-and-variety-of.jpg?w=1200&h=1200&s=1',
    about:
        'A scenic lake popular for its vibrant nightlife and serene evening views.',
    features: ['Scenic beauty', 'Evening spot', 'Local food stalls'],
  ),
  Location(
    name: 'Taj Mahal',
    locality: 'Agra, Uttar Pradesh',
    image: 'https://upload.wikimedia.org/wikipedia/commons/d/da/Taj-Mahal.jpg',
    about: 'An iconic symbol of love and a UNESCO World Heritage Site.',
    features: ['Mughal architecture', 'Marble dome', 'Heritage site'],
  ),
  Location(
    name: 'Gateway of India',
    locality: 'Mumbai, Maharashtra',
    image:
        'https://3.bp.blogspot.com/-dQ1gcVL5A3o/Vhqj9ydvuQI/AAAAAAAAJ5U/uk1_d8CkHwM/s1600/Gateway-of-India-Nightview.jpg',
    about: 'A monumental arch symbolizing India’s colonial history.',
    features: ['Historical monument', 'Seafront views', 'Cultural events'],
  ),
  Location(
    name: 'Manali',
    locality: 'Himachal Pradesh',
    image:
        'https://pyt-blogs.imgix.net/2020/07/Manali.jpg?auto=format&ixlib=php-3.3.0',
    about:
        'A beautiful hill station known for its snow-capped mountains and adventure activities.',
    features: ['Hill station', 'Snow sports', 'Adventure activities'],
  ),
  Location(
    name: 'Anjuna Beach',
    locality: 'Goa',
    image:
        'https://www.holidify.com/images/cmsuploads/compressed/shutterstock_1065723824_20190822151024.jpg',
    about:
        'A popular beach in Goa, known for its vibrant nightlife and flea markets.',
    features: ['Beach', 'Nightlife', 'Flea markets'],
  ),
  Location(
    name: 'Dal Lake',
    locality: 'Srinagar',
    image:
        'https://d2rdhxfof4qmbb.cloudfront.net/wp-content/uploads/20190312112932/Shikara-boats-on-Dal-lake-Srinagar.jpg',
    about: 'Known for its iconic houseboats and breathtaking views.',
    features: ['Lake', 'Houseboats', 'Scenic views'],
  ),
  Location(
    name: 'Ranthambore National Park',
    locality: 'Rajasthan',
    image:
        'https://tse2.mm.bing.net/th?id=OIP.ydvhdcpoiUR__tVPJ5cQfQHaE8&pid=Api&P=0&h=180',
    about: 'A premier tiger reserve and wildlife destination in India.',
    features: ['Wildlife sanctuary', 'Tiger reserve', 'Safari'],
  ),
  Location(
    name: 'Calangute Beach',
    locality: 'Goa',
    image:
        'https://tse1.mm.bing.net/th?id=OIP.9U6aueXCB9BCY3blHSGgWAHaFj&pid=Api&P=0&h=180',
    about:
        'The largest beach in North Goa, famous for its water sports and beautiful coastline.',
    features: ['Beach', 'Water sports', 'Tourist attraction'],
  ),
  Location(
    name: 'Kerala Backwaters',
    locality: 'Alleppey',
    image: 'https://wallpaperaccess.com/full/5180712.jpg',
    about: 'Famous for its serene backwaters and traditional houseboats.',
    features: ['Backwaters', 'Houseboats', 'Nature'],
  ),
  Location(
    name: 'Havelock Island',
    locality: 'Andaman & Nicobar Islands',
    image:
        'https://tse1.mm.bing.net/th?id=OIP.7QFvcbwiLu8sH5jxGXRSNQHaFj&pid=Api&P=0&h=180',
    about: 'Known for its white sandy beaches and clear blue waters.',
    features: ['Island', 'Beaches', 'Snorkeling'],
  ),
  Location(
    name: 'Cherrapunji',
    locality: 'Meghalaya',
    image:
        'https://cdn.britannica.com/16/173816-050-C1A68488/Seven-Sisters-Falls-Cherrapunji-India.jpg',
    about:
        'Known as the wettest place on earth, famous for its living root bridges.',
    features: ['Hill station', 'Living root bridges', 'Waterfalls'],
  ),
  Location(
    name: 'Ellora Caves',
    locality: 'Aurangabad',
    image:
        'https://tse1.mm.bing.net/th?id=OIP.owSpbYRiWY2f-MmjX9W_eQHaE7&pid=Api&P=0&h=180',
    about: 'A UNESCO World Heritage Site featuring ancient rock-cut temples.',
    features: ['Caves', 'Historical site', 'Architecture'],
  ),
  Location(
    name: 'Charminar',
    locality: 'Hyderabad, Telangana',
    image:
        'https://tse1.mm.bing.net/th?id=OIP.-hqCQVkDmkuTvd24Os8AZAHaF_&pid=Api&P=0&h=180',
    about: 'A 16th-century mosque and iconic landmark of Hyderabad.',
    features: ['Islamic architecture', 'Market area', 'Heritage site'],
  ),
  Location(
    name: 'Mysore Palace',
    locality: 'Mysuru, Karnataka',
    image:
        'https://cdn.britannica.com/27/242227-050-48358A10/Mysore-Palace-Mysuru-Karnataka-India.jpg',
    about: 'A grand palace known for its architectural brilliance and history.',
    features: ['Royal architecture', 'Light and sound show', 'Cultural events'],
  ),
  Location(
    name: 'Golden Temple',
    locality: 'Amritsar, Punjab',
    image:
        'https://tse3.mm.bing.net/th?id=OIP.CBXijkYXb4bGCCELFdQhqgHaFj&pid=Api&P=0&h=180',
    about: 'A spiritual site and the holiest Gurdwara of Sikhism.',
    features: [
      'Spiritual atmosphere',
      'Langar (community kitchen)',
      'Beautiful architecture'
    ],
  ),
  Location(
    name: 'Meenakshi Temple',
    locality: 'Madurai, Tamil Nadu',
    image:
        'https://assets.atlasobscura.com/media/W1siZiIsInVwbG9hZHMvcGxhY2VfaW1hZ2VzL2JjOTdjMDA5YmE1MTNmZDRhOV8zNjIyMzA0ODQzX2EwNmNhNGI0MjFfby5qcGciXSxbInAiLCJ0aHVtYiIsIjEyMDB4PiJdLFsicCIsImNvbnZlcnQiLCItcXVhbGl0eSA4MSAtYXV0by1vcmllbnQiXV0/3622304843_a06ca4b421_o.jpg',
    about:
        'A historic Hindu temple known for its intricate carvings and architecture.',
    features: ['Dravidian architecture', 'Colorful carvings', 'Spiritual site'],
  ),
  Location(
    name: 'Hawa Mahal',
    locality: 'Jaipur, Rajasthan',
    image:
        'https://static.vecteezy.com/system/resources/previews/002/856/313/large_2x/hawa-mahal-on-evening-jaipur-rajasthan-india-photo.jpg',
    about:
        'A unique palace designed for royal women to observe street festivals.',
    features: [
      'Unique facade',
      'Rajasthani architecture',
      'Cultural significance'
    ],
  ),
  Location(
    name: 'Rann of Kutch',
    locality: 'Kutch, Gujarat',
    image:
        'https://tse1.mm.bing.net/th?id=OIP.QY7HWRDswufdyhnfCx04gwHaGA&pid=Api&P=0&h=180',
    about: 'A vast white salt desert offering a unique landscape.',
    features: ['Salt desert', 'Rann Utsav festival', 'Cultural showcase'],
  ),
  Location(
    name: 'Konark Sun Temple',
    locality: 'Konark, Odisha',
    image:
        'https://tse3.mm.bing.net/th?id=OIP.rRvv1Ym7RhiB2f08Aco_IAHaEU&pid=Api&P=0&h=180',
    about: 'A 13th-century temple dedicated to the Sun God.',
    features: ['Chariot-shaped design', 'UNESCO site', 'Intricate sculptures'],
  ),
];
