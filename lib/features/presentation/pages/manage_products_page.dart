// import 'package:flutter/material.dart';

// import '../widgets/product_card.dart';

// class ManageProductsPage extends StatelessWidget {
//   const ManageProductsPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Manage Products',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 24,
//           ),
//         ),
//         elevation: 0,
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Add, edit, or delete products.',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.black54,
//               ),
//             ),
//             const SizedBox(height: 24),
//             Expanded(
//               child: GridView.builder(
//                 gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
//                   maxCrossAxisExtent: 250,
//                   childAspectRatio: 0.75,
//                   crossAxisSpacing: 24,
//                   mainAxisSpacing: 24,
//                 ),
//                 itemCount: 10, // Example count, replace with your data
//                 itemBuilder: (context, index) {
//                   if (index == 0) {
//                     return _buildAddProductCard(context);
//                   }
//                   return const ProductCard(
//                     imagePath: 'https://via.placeholder.com/150',
//                     name: 'Sample Product',
//                     category: 'Category',
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAddProductCard(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         print('Add New Product tapped!');
//       },
//       borderRadius: BorderRadius.circular(16),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: const [
//             BoxShadow(
//               color: Colors.black,
//               blurRadius: 8,
//               spreadRadius: 2,
//               offset: Offset(0, 4),
//             ),
//           ],
//           border: Border.all(
//             color: Colors.grey,
//             width: 1,
//           ),
//         ),
//         child: const Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.add,
//                 size: 50,
//                 color: Colors.deepPurple,
//               ),
//               SizedBox(height: 12),
//               Text(
//                 'Add New Product',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black87,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
