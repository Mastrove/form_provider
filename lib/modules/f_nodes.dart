import 'package:flutter/widgets.dart';

class FNodes {
  Map<String, FocusNode> nodesMap = {};
  List<FocusNode> nodesArray = [];
  BuildContext context;

  FNodes({this.context});

  FocusNode getNode(String nodeName) {
    final node = nodesMap.putIfAbsent(nodeName, () => FocusNode(debugLabel: nodeName));
    nodesArray = nodesMap.values.toList();
    return node;
  }

  void disposeNode(String nodeName) {
    if (!nodesMap.containsKey(nodeName)) return;
    nodesMap[nodeName].dispose();
    nodesMap.remove(nodeName);
  }

  void transferNext(String current, { bool skip = false }) {
    if (context == null) throw Exception('build context not found');
    if (!nodesMap.containsKey(current)) throw Exception('start node $current not found');

    final currentNode = nodesMap[current];
    currentNode.unfocus();

    if (nodesArray.last == currentNode) return;
    final nextNode = nodesArray[nodesArray.indexOf(currentNode) + 1];

    FocusScope.of(context).requestFocus(nextNode);
  }

  void transferFocus(String current, [String next]) {
    if (context == null) throw Exception('build context not found');
    if (!nodesMap.containsKey(current)) throw Exception('start node $current not found');
    nodesMap[current].unfocus();
    if (next == null) return;
    if (!nodesMap.containsKey(next)) throw Exception('destination node $next not found');
    FocusScope.of(context).requestFocus(nodesMap[next]);
  }

  void removeFocus() {
    nodesMap.forEach((_, node) => node.unfocus());
  }

  void dispose() {
    nodesMap.forEach((_, node) => node.dispose());
    nodesMap.clear();
  }

  void clear() {
    // nodesMap.forEach((_, node) => node.dispose());
    nodesMap.clear();
  }
}