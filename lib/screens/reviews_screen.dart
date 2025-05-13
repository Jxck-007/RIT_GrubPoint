import 'package:flutter/material.dart';

class ReviewsScreen extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;

  const ReviewsScreen({
    Key? key,
    this.restaurantId = 'my-reviews',
    this.restaurantName = 'My Reviews',
  }) : super(key: key);

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  final List<Review> _reviews = [];
  final _formKey = GlobalKey<FormState>();
  final _reviewController = TextEditingController();
  double _rating = 3.0;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _loadReviews() async {
    // Simulating API call to fetch reviews
    await Future.delayed(const Duration(milliseconds: 800));
    
    setState(() {
      _reviews.addAll([
        Review(
          id: '1',
          userName: 'John D.',
          rating: 4.5,
          comment: 'Great food and fast service! Would definitely order again.',
          date: DateTime.now().subtract(const Duration(days: 2)),
          helpfulCount: 5,
        ),
        Review(
          id: '2',
          userName: 'Sarah M.',
          rating: 3.0,
          comment: 'Food was good but delivery took longer than expected.',
          date: DateTime.now().subtract(const Duration(days: 5)),
          helpfulCount: 2,
        ),
        Review(
          id: '3',
          userName: 'Mike T.',
          rating: 5.0,
          comment: 'Absolutely delicious! Best campus food I\'ve had.',
          date: DateTime.now().subtract(const Duration(days: 10)),
          helpfulCount: 7,
        ),
        Review(
          id: '4',
          userName: 'Emma L.',
          rating: 2.5,
          comment: 'Order was missing items. Customer service was helpful though.',
          date: DateTime.now().subtract(const Duration(days: 15)),
          helpfulCount: 1,
        ),
      ]);
    });
  }

  Future<void> _submitReview() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      // Simulating API call to submit review
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _reviews.insert(
          0,
          Review(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            userName: 'You',
            rating: _rating,
            comment: _reviewController.text,
            date: DateTime.now(),
            helpfulCount: 0,
          ),
        );
        _reviewController.clear();
        _rating = 3.0;
        _isSubmitting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Review submitted successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews - ${widget.restaurantName}'),
      ),
      body: Column(
        children: [
          // Overall rating card
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _calculateAverageRating(),
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            index < double.parse(_calculateAverageRating()).floor()
                                ? Icons.star
                                : index + 0.5 == double.parse(_calculateAverageRating())
                                    ? Icons.star_half
                                    : Icons.star_border,
                            color: Colors.amber,
                            size: 18,
                          ),
                        ),
                      ),
                      Text(
                        '${_reviews.length} reviews',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: List.generate(
                        5,
                        (index) {
                          final ratingCount = 5 - index;
                          final count = _reviews.where(
                            (review) => review.rating.round() == ratingCount,
                          ).length;
                          final percentage = _reviews.isEmpty
                              ? 0.0
                              : count / _reviews.length;
                          
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              children: [
                                Text('$ratingCount'),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: LinearProgressIndicator(
                                    value: percentage,
                                    backgroundColor: Colors.grey[300],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Submit review form
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Write a Review',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Rating: '),
                        Row(
                          children: List.generate(
                            5,
                            (index) => IconButton(
                              icon: Icon(
                                index < _rating
                                    ? Icons.star
                                    : index + 0.5 == _rating
                                        ? Icons.star_half
                                        : Icons.star_border,
                                color: Colors.amber,
                              ),
                              onPressed: () {
                                setState(() {
                                  _rating = index + 1.0;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: _reviewController,
                      decoration: const InputDecoration(
                        hintText: 'Share your experience',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your review';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitReview,
                        child: _isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Submit Review'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Reviews list
          Expanded(
            child: _reviews.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.rate_review_outlined,
                          size: 70,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No reviews yet',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          'Be the first to leave a review!',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _reviews.length,
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      final review = _reviews[index];
                      return ReviewCard(
                        review: review,
                        onHelpful: () {
                          setState(() {
                            review.helpfulCount++;
                          });
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _calculateAverageRating() {
    if (_reviews.isEmpty) {
      return '0.0';
    }
    final sum = _reviews.fold(0.0, (prev, review) => prev + review.rating);
    return (sum / _reviews.length).toStringAsFixed(1);
  }
}

class ReviewCard extends StatelessWidget {
  final Review review;
  final VoidCallback onHelpful;

  const ReviewCard({
    Key? key,
    required this.review,
    required this.onHelpful,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  review.userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  _getFormattedDate(review.date),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: List.generate(
                5,
                (index) => Icon(
                  index < review.rating
                      ? Icons.star
                      : index + 0.5 == review.rating
                          ? Icons.star_half
                          : Icons.star_border,
                  color: Colors.amber,
                  size: 16,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(review.comment),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${review.helpfulCount} ${review.helpfulCount == 1 ? 'person' : 'people'} found this helpful',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                TextButton.icon(
                  onPressed: onHelpful,
                  icon: const Icon(Icons.thumb_up_outlined, size: 16),
                  label: const Text('Helpful'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getFormattedDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays < 1) {
      return 'Today';
    } else if (difference.inDays < 2) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

class Review {
  final String id;
  final String userName;
  final double rating;
  final String comment;
  final DateTime date;
  int helpfulCount;

  Review({
    required this.id,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
    required this.helpfulCount,
  });
} 