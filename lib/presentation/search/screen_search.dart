import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxtube/application/application.dart';
import 'package:fluxtube/core/colors.dart';
import 'package:fluxtube/core/enums.dart';
import 'package:fluxtube/generated/l10n.dart';
import 'package:fluxtube/widgets/widgets.dart';

import 'widgets/widgets.dart';

class ScreenSearch extends StatefulWidget {
  const ScreenSearch({super.key});

  @override
  State<ScreenSearch> createState() => _ScreenSearchState();
}

class _ScreenSearchState extends State<ScreenSearch> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locals = S.of(context);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: kBlackColor,
        title: SearchBarSection(
            textEditingController: _textEditingController, theme: theme),
      ),
      body: SafeArea(child: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state.isSuggestionDisplay == true &&
              state.fetchSuggestionStatus == ApiStatus.loaded &&
              state.suggestions.isNotEmpty &&
              _textEditingController.text.isNotEmpty) {
            return SearchSuggessionSection(
              textEditingController: _textEditingController,
              state: state,
            );
          } else if (state.fetchSearchResultStatus == ApiStatus.loading ||
              state.fetchSearchResultStatus == ApiStatus.initial) {
            return cIndicator(context);
          } else if (state.isSuggestionDisplay ||
              _textEditingController.text.isEmpty) {
            return Container();
          } else if (state.fetchSearchResultStatus == ApiStatus.error ||
              state.result == null ||
              state.result!.items.isEmpty) {
            return ErrorRetryWidget(
              lottie: 'assets/cup.zip',
              onTap: () => BlocProvider.of<SearchBloc>(context).add(
                  SearchEvent.getSearchResult(
                      query: _textEditingController.text, filter: "all")),
            );
          } else {
            return SearcheResultSection(
              locals: locals,
              state: state,
              searchQuery: _textEditingController.text,
            );
          }
        },
      )),
    );
  }
}
