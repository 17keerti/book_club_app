import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_club_app/models/book.dart'; 

// Defines the available sorting options for the book list
enum SortType {
  author,
  title,
}

// States 
abstract class BookListState {
  const BookListState();
}

// Initial state before any data is loaded
class BookListInitial extends BookListState {}

// Main state holding the list of books and UI configuration
class BookListLoaded extends BookListState {
  final List<Book> books;
  final SortType currentSortType; 
  final bool showDetail;
  final Book? selectedBook;

  // Constructor for the loaded state
  const BookListLoaded({
    required this.books,
    this.currentSortType = SortType.author, 
    this.showDetail = false,
    this.selectedBook,
  });

  // Creates a new instance of the state by copying existing values.
  BookListLoaded copyWith({
    List<Book>? books,
    SortType? currentSortType,
    bool? showDetail,
    Book? selectedBook,
  }) {
    return BookListLoaded(
      books: books != null ? List.of(books) : List.of(this.books),
      currentSortType: currentSortType ?? this.currentSortType,
      showDetail: showDetail ?? this.showDetail,
      selectedBook: selectedBook, 
    );
  }
}

// Cubit
class BookListCubit extends Cubit<BookListState> {
  // Holds the complete, unsorted list of all books
  List<Book> _allBooks = [];

  // Constructor: loads the initial data immediately
  BookListCubit() : super(BookListInitial()) {
    loadBooks(); 
  }

  // Loads the initial book list data and emits the first loaded state
  void loadBooks() { 
    _allBooks = _getInitialBookList();
    final sortedBooks = _sortBooks(_allBooks, SortType.author);

  // Emits the loaded state with the list sorted by the default criteria (Author)
    emit(BookListLoaded(
      books: sortedBooks,
      currentSortType: SortType.author,
    ));
  }

  // Handles the logic for sorting the book list based on user selection
  void sortBooks(SortType newSortType) {
    if (state is BookListLoaded) {
      final currentState = state as BookListLoaded;

      if (currentState.currentSortType == newSortType) return;

      final sortedBooks = _sortBooks(_allBooks, newSortType);

      // Emits a new state with the sorted list and updated sort type
      emit(currentState.copyWith(
        books: sortedBooks,
        currentSortType: newSortType,
      ));
    }
  }

  // Helper method to perform the actual sorting logic (by Author or Title)
  List<Book> _sortBooks(List<Book> books, SortType sortType) {
    final List<Book> mutableList = List.of(_allBooks); 

    if (sortType == SortType.author) {
      mutableList.sort((a, b) => a.author.toLowerCase().compareTo(b.author.toLowerCase()));
    } else { 
      mutableList.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    }
    return mutableList;
  }

  // Transitions the state to show the detail view for the selected book
  void navigateToDetail(Book book) {
    if (state is BookListLoaded) {
      final currentState = state as BookListLoaded;
      emit(currentState.copyWith(
        showDetail: true,
        selectedBook: book,
      ));
    }
  }

  // Transitions the state back to the list view, clearing the selected book
  void navigateToList() {
    if (state is BookListLoaded) {
      final currentState = state as BookListLoaded;
      emit(currentState.copyWith(
        showDetail: false,
        selectedBook: null,
      ));
    }
  }

  // Generates the initial, hardcoded list of books
  List<Book> _getInitialBookList() {
    return [
      Book(
        title: 'Carmilla Grit',
        author: 'Susan Dene Herbers',
        imageUrl: 'assets/charmer.png',
        description: 'A dark tale of courage and discovery in a mythical world.',
      ),
      Book(
        title: 'little gods',
        author: 'Meng Jin',
        imageUrl: 'assets/littleGods.png',
        description: 'An expansive and intimate novel exploring motherhood, migration, and the Chinese diaspora.',
      ),
      Book(
        title: 'A Clockwork Orange',
        author: 'Anthony Burgess',
        imageUrl: 'assets/clockwork.png',
        description: 'A disturbing yet thought-provoking look at the nature of morality and free will.',
      ),
      Book(
        title: 'The Memory of Water',
        author: 'Emmi Itäranta',
        imageUrl: 'assets/memory.png',
        description: 'In a world ravaged by environmental disaster, a young woman guards a dangerous secret.',
      ),
      Book(
        title: 'The Big Deal',
        author: 'Hisham Al Gurg',
        imageUrl: 'assets/bigDeal.png',
        description: '5 Steps Formula: An inspirational guide to success in business.',
      ),
      Book(
        title: 'Don\'t Look Back',
        author: 'Isaac Nelson',
        imageUrl: 'assets/dontLook.png',
        description: 'Voted Best Thriller Novel 20XX. A gripping mystery.',
      ),
      Book(
        title: 'James and the Giant Peach',
        author: 'Roald Dahl',
        imageUrl: 'assets/giantPeach.png',
        description: 'The whimsical and bizarre adventures of an orphan boy inside a massive piece of fruit.',
      ),
    ];
  }
}