// lib/pages/home_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/book_list_cubit.dart'; 
import '../widgets/book_widgets.dart';
import '../models/book.dart';

// Main UI Component
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookListCubit, BookListState>(
      builder: (context, state) {

        if (state is BookListInitial) { 
          return Scaffold(
            appBar: AppBar(title: const Text('Book Club Home')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is BookListLoaded) {
          if (state.showDetail && state.selectedBook != null) {
            return _BookDetailPage(book: state.selectedBook!);
          }

          return _BookListPage(state: state);
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Book Club Home')),
          body: const Center(child: Text('An unexpected error occurred.')),
        );
      },
    );
  }
}

// List View Widget
class _BookListPage extends StatelessWidget {
  final BookListLoaded state;

  const _BookListPage({required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BookListCubit>(); // Read the Cubit

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: null,
        ),
        title: const Text('Book Club Home'),
        flexibleSpace: SafeArea(
          child: Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(top: 6.0),
            child: Container(
              width: double.infinity,
              height: 42.0,
              decoration: const BoxDecoration(
                color: Color(0xFFFFF1F5),
              ),
            ),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.person_outline),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Text('Sort by '),
                // Author Button
                FilterChip(
                  label: const Text('Author'),
                  selected: state.currentSortType == SortType.author,
                  onSelected: (bool selected) {
                    if (!selected) return; 
                    cubit.sortBooks(SortType.author); // Direct Cubit method call
                  },
                ),
                const SizedBox(width: 8),
                // Title Button
                FilterChip(
                  label: const Text('Title'),
                  selected: state.currentSortType == SortType.title,
                  onSelected: (bool selected) {
                    if (!selected) return;
                    cubit.sortBooks(SortType.title); // Direct Cubit method call
                  },
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              'Books',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 250, 
            child: ListView.builder(
              scrollDirection: Axis.horizontal, 
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              itemCount: state.books.length,
              itemBuilder: (context, index) {
                final book = state.books[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: InkWell(
                    onTap: () {
                      cubit.navigateToDetail(book);
                    },
                    child: SizedBox(
                      width: 150, 
                      child: BookCoverImage(book: book),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}


// Book Detail View Widget
class _BookDetailPage extends StatelessWidget {
  final Book book;

  const _BookDetailPage({required this.book});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BookListCubit>(); 

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Detail'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            cubit.navigateToList(); 
          },
        ),
        flexibleSpace: SafeArea(
          child: Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(top: 6.0),
            child: Container(
              width: double.infinity,
              height: 42.0,
              decoration: const BoxDecoration(
                color: Color(0xFFFFF1F5),
              ),
            ),
          ),
        ),
      ),
      body: BookDetailCard(book: book),
    );
  }
}