class ImageUrlHelper {
  static String fix(String baseUrl, String pathOrUrl) {
    if (pathOrUrl.isEmpty) return '';
    if (pathOrUrl.startsWith('http')) return pathOrUrl;

    var p = pathOrUrl;
    if (p.startsWith('/images/')) {
      p = p.replaceFirst('/images/', '/storage/');
    } else if (!p.startsWith('/storage/')) {
      if (p.startsWith('/')) {
        p = '/storage${p}';
      } else {
        p = '/storage/$p';
      }
    }

    final b = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    return Uri.parse('$b$p').toString();
  }
}
