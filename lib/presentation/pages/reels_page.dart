// import 'package:flutter/material.dart';
// import 'package:ulearna_reels/presentation/bloc/reels_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
//
//
import 'index.dart';

class ReelsPage extends StatefulWidget {
  const ReelsPage({Key? key}) : super(key: key);

  @override
  State<ReelsPage> createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage> {
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Initial fetch of reels
    context.read<ReelsBloc>().add(
      const FetchReels(limit: 10, country: 'United+States'),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<ReelsBloc>().add(FetchMoreReels());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    // Load more when we're 70% of the way to the bottom  
    return currentScroll >= (maxScroll * 0.7);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reels'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ReelsBloc>().add(const RefreshReels());
            },
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<ReelsBloc, ReelsState>(
          builder: (context, state) {
            if (state is ReelsInitial || state is ReelsLoading) {
              return const LoadingWidget(message: 'Loading reels...');
            } else if (state is ReelsLoaded) {
              if (state.reels.isEmpty) {
                return const Center(child: Text('No reels available'));
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ReelsBloc>().add(const RefreshReels());
                },
                child: PageView.builder(
                  scrollDirection: Axis.vertical,
                  controller: _pageController,
                  scrollBehavior: const ScrollBehavior().copyWith(
                    overscroll: false,
                  ),
                  itemCount: state.reels.length + (state.hasReachedMax ? 0 : 1),
                  itemBuilder: (context, index) {
                    // Show bottom loader when we reach the end and there are more reels to load
                    if (index >= state.reels.length) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // Normal reel card
                    return ReelCard(reel: state.reels[index]);
                  },
                ),
              );
            } else if (state is ReelsError) {
              return ErrorDisplayWidget(
                message: state.message,
                onRetry: () {
                  context.read<ReelsBloc>().add(const FetchReels());
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
