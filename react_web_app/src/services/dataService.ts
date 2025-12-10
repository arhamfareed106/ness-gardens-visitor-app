/**
 * Filters plants where accsta === "C"
 * @param plants Array of plant objects from API
 * @returns Filtered array of plants
 */
export function filterPlantsByAccsta(plants: any[]): any[] {
  return plants.filter(plant => plant.accsta === 'C');
}

/**
 * Parses bed string into array of bed IDs
 * @param bedString String containing space-separated bed IDs (e.g., "PW1 PW2 L-2")
 * @returns Array of bed IDs
 */
export function parseBedString(bedString: string): string[] {
  if (!bedString || typeof bedString !== 'string') {
    return [];
  }
  return bedString.trim().split(/\s+/);
}

/**
 * Performs upsert operation (insert or update) based on primary key
 * @param items Array of existing items
 * @param newItem New item to insert or update
 * @param primaryKey Key to use for comparison (e.g., 'recnum')
 * @returns Updated array of items
 */
export function upsertItem<T>(items: T[], newItem: T, primaryKey: keyof T): T[] {
  const index = items.findIndex(item => item[primaryKey] === newItem[primaryKey]);
  
  if (index !== -1) {
    // Update existing item
    return [
      ...items.slice(0, index),
      newItem,
      ...items.slice(index + 1)
    ];
  } else {
    // Insert new item
    return [...items, newItem];
  }
}