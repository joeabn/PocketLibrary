import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pocket_library/services/confirmation_dialog.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../Database/DatabaseContext.dart';
import '../Database/book.dart';
import '../constants.dart';
import '../widgets/search_toolbar.dart';

class ReadingScreen extends StatefulWidget {
  final Book book;

  const ReadingScreen({Key? key, required this.book}) : super(key: key);

  @override
  _ReadingState createState() => _ReadingState();
}

class _ReadingState extends State<ReadingScreen> {
  late PdfViewerController _pdfViewerController;
  final GlobalKey<SfPdfViewerState> _pdfViewerStateKey = GlobalKey();
  final GlobalKey<SearchToolbarState> _textSearchKey = GlobalKey();

  OverlayEntry? _overlayEntry;
  late bool _showScrollHead;
  late bool _showToolbar;
  late Book _book;

  void updateBookmark() {
    _book.bookmark = _pdfViewerController.pageNumber;
    saveCurrentBookRead();
  }

  /// Ensure the entry history of Text search.
  LocalHistoryEntry? _historyEntry;

  @override
  void initState() {
    _book = widget.book;
    _book.isCurrent = true;
    _pdfViewerController = PdfViewerController();
    _pdfViewerController.jumpToPage(_book.bookmark);
    _showScrollHead = true;
    _showToolbar = false;
    super.initState();
  }

  Future<void> openSaveWarningDialog() async {
    await ConfirmationDialogService.openConfirmation(
        context,
        "Save your progress",
        "Are you sure you want to exit without saving your reading progress ?",
        [
          TextButton(
            child: Text("Save and Exit"),
            onPressed: () {
              updateBookmark();
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text(
              "Exit Without Saving",
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ]);
  }

  Future<void> saveCurrentBookRead() async {
    final DatabaseHandler _db = DatabaseHandler();
    await _db.updateCurrentBook(_book);
  }

  @override
  void dispose() {
    saveCurrentBookRead();
    super.dispose();
  }

  void _showContextMenu(
      BuildContext context, PdfTextSelectionChangedDetails details) {
    final OverlayState _overlayState = Overlay.of(context)!;
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: details.globalSelectedRegion!.center.dy - 55,
        left: details.globalSelectedRegion!.bottomLeft.dx,
        child: ElevatedButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: details.selectedText));
            print(
                'Text copied to clipboard: ' + details.selectedText.toString());
            _pdfViewerController.clearSelection();
          },
          child: const Text('Copy', style: const TextStyle(fontSize: 17)),
        ),
      ),
    );
    _overlayState.insert(_overlayEntry!);
  }

  /// Ensure the entry history of text search.
  void _ensureHistoryEntry() {
    if (_historyEntry == null) {
      final ModalRoute<dynamic>? route = ModalRoute.of(context);
      if (route != null) {
        _historyEntry = LocalHistoryEntry(onRemove: _handleHistoryEntryRemoved);
        route.addLocalHistoryEntry(_historyEntry!);
      }
    }
  }

  /// Remove history entry for text search.
  void _handleHistoryEntryRemoved() {
    _textSearchKey.currentState?.clearSearch();
    setState(() {
      _showToolbar = false;
    });
    _historyEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          await openSaveWarningDialog();
          return true;
        },
        child: SafeArea(
            child: Scaffold(
                appBar: _showToolbar
                    ? AppBar(
                        flexibleSpace: SafeArea(
                          child: SearchToolbar(
                            key: _textSearchKey,
                            showTooltip: true,
                            controller: _pdfViewerController,
                            onTap: (Object toolbarItem) async {
                              if (toolbarItem.toString() == 'Cancel Search') {
                                setState(() {
                                  _showToolbar = false;
                                  _showScrollHead = true;
                                  if (Navigator.canPop(context)) {
                                    Navigator.maybePop(context);
                                  }
                                });
                              }
                              if (toolbarItem.toString() == 'noResultFound') {
                                setState(() {
                                  _textSearchKey.currentState?.showToast = true;
                                });
                                await Future.delayed(
                                    const Duration(seconds: 1));
                                setState(() {
                                  _textSearchKey.currentState?.showToast =
                                      false;
                                });
                              }
                            },
                          ),
                        ),
                        backgroundColor: kRedColor,
                      )
                    : AppBar(
                        title: Text(_book.title),
                        actions: <Widget>[
                          IconButton(
                            icon: const Icon(
                              Icons.search,
                            ),
                            onPressed: () {
                              setState(() {
                                _showScrollHead = false;
                                _showToolbar = true;
                                _ensureHistoryEntry();
                              });
                            },
                          ),
                          IconButton(
                              onPressed: () async {
                                updateBookmark();
                              },
                              icon: const Icon(
                                Icons.bookmark,
                              )),
                          IconButton(
                              onPressed: () {
                                _pdfViewerController.jumpToPage(5);
                              },
                              icon: const Icon(
                                Icons.arrow_drop_down_circle,
                              ))
                        ],
                        backgroundColor: kRedColor),
                body: Stack(
                  children: [
                    SfPdfViewer.network(_book.path, onTextSelectionChanged:
                            (PdfTextSelectionChangedDetails details) {
                      if (details.selectedText == null &&
                          _overlayEntry != null) {
                        _overlayEntry!.remove();
                        _overlayEntry = null;
                      } else if (details.selectedText != null &&
                          _overlayEntry == null) {
                        _showContextMenu(context, details);
                      }
                    },
                        pageLayoutMode: PdfPageLayoutMode.continuous,
                        scrollDirection: PdfScrollDirection.vertical,
                        canShowScrollHead: _showScrollHead,
                        controller: _pdfViewerController,
                        key: _pdfViewerStateKey),
                    Visibility(
                      visible: _textSearchKey.currentState?.showToast ?? false,
                      child: Align(
                        alignment: Alignment.center,
                        child: Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 15, top: 7, right: 15, bottom: 7),
                              decoration: BoxDecoration(
                                color: Colors.grey[600],
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(16.0),
                                ),
                              ),
                              child: const Text(
                                'No result',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 16,
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ))));
  }
}
