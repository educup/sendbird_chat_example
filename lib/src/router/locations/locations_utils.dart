import 'package:beamer/beamer.dart';

extension BeamStateParams on BeamState {
  bool matchSegment(int segment, String pattern) {
    if (uri.pathSegments.length <= segment) return false;

    return uri.pathSegments[segment] == pattern;
  }

  bool lenGreaterThan(int len) => uri.pathSegments.length > len;
}
