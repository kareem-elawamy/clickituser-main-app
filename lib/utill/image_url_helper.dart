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
  
  // 1. If the API already returns a full, valid URL, use it directly.
  if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
    return imagePath;
  }
  
  // 2. Otherwise, safely concatenate the base URL and the relative path.
  final String base = baseUrl?.endsWith('/') == true 
      ? baseUrl!.substring(0, baseUrl.length - 1) 
      : baseUrl ?? '';
      
  final String path = imagePath.startsWith('/') 
      ? imagePath.substring(1) 
      : imagePath;
  
  return '$base/$path';
}
