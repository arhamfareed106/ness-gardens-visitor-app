/**
 * Calculates the distance between two geographical points using the Haversine formula
 * @param lat1 Latitude of point 1
 * @param lon1 Longitude of point 1
 * @param lat2 Latitude of point 2
 * @param lon2 Longitude of point 2
 * @returns Distance in kilometers
 */
export function haversineDistance(lat1: number, lon1: number, lat2: number, lon2: number): number {
  const R = 6371; // Earth radius in kilometers
  const dLat = (lat2 - lat1) * Math.PI / 180;
  const dLon = (lon2 - lon1) * Math.PI / 180;
  const a = 
    Math.sin(dLat/2) * Math.sin(dLat/2) +
    Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) * 
    Math.sin(dLon/2) * Math.sin(dLon/2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
  return R * c;
}

/**
 * Sorts beds by distance from a given location
 * @param beds Array of bed objects with latitude and longitude
 * @param userLat User's current latitude
 * @param userLon User's current longitude
 * @returns Beds sorted by distance (nearest first)
 */
export function sortBedsByDistance(
  beds: { id: string; name: string; latitude: number; longitude: number }[], 
  userLat: number, 
  userLon: number
): { id: string; name: string; latitude: number; longitude: number; distance: number }[] {
  return beds
    .map(bed => {
      const distance = haversineDistance(userLat, userLon, bed.latitude, bed.longitude);
      return { ...bed, distance };
    })
    .sort((a, b) => a.distance - b.distance);
}