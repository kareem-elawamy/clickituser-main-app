/// Returns the full image URL using the authoritative [baseUrl] from config.
///
/// When a [baseUrl] is provided, the filename is always extracted from
/// [imagePath] (whether it is a full URL or a relative path) and appended
/// to [baseUrl].  This ensures we use the canonical storage path defined
/// in `/api/v1/config → base_urls` rather than potentially stale full URLs
/// returned by other API endpoints.
///
/// Falls back to the raw [imagePath] only when [baseUrl] is null/empty.
/// Returns an empty string when [imagePath] is null or empty.
String getFullImageUrl(String? baseUrl, String? imagePath) {
  if (imagePath == null || imagePath.isEmpty) return '';

  // Extract just the filename from the path (works for both full URLs and
  // relative paths like "image.webp" or "subfolder/image.webp").
  final String filename = imagePath.contains('/')
      ? imagePath.split('/').last
      : imagePath;

  if (filename.isEmpty) return '';

  // If we have an authoritative base URL, always build from it.
  if (baseUrl != null && baseUrl.isNotEmpty) {
    return '$baseUrl/$filename';
  }

  // No base URL available — return the original path as a best-effort.
  return imagePath;
}
