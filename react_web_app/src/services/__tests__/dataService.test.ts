import { filterPlantsByAccsta, parseBedString, upsertItem } from '../dataService';

// Mock Jest globals for TypeScript
declare var describe: (suiteName: string, callback: () => void) => void;
declare var test: (testName: string, callback: () => void) => void;
declare var expect: (actual: any) => { 
  toBe: (expected: any) => void;
  toEqual: (expected: any) => void;
  toHaveLength: (expected: number) => void;
  toBeCloseTo: (expected: number, precision?: number) => void;
};

describe('filterPlantsByAccsta', () => {
  test('filters plants with accsta === "C"', () => {
    const mockPlants = [
      { recnum: 1, name: 'Plant A', accsta: 'C' },
      { recnum: 2, name: 'Plant B', accsta: 'X' },
      { recnum: 3, name: 'Plant C', accsta: 'C' },
      { recnum: 4, name: 'Plant D', accsta: 'D' }
    ];

    const filteredPlants = filterPlantsByAccsta(mockPlants);
    
    expect(filteredPlants).toHaveLength(2);
    expect(filteredPlants[0].accsta).toBe('C');
    expect(filteredPlants[1].accsta).toBe('C');
    expect(filteredPlants[0].name).toBe('Plant A');
    expect(filteredPlants[1].name).toBe('Plant C');
  });
});

describe('parseBedString', () => {
  test('parses bed string into array of bed IDs', () => {
    const bedString = 'PW1 PW2 L-2';
    const result = parseBedString(bedString);
    
    expect(result).toEqual(['PW1', 'PW2', 'L-2']);
  });

  test('handles extra whitespace', () => {
    const bedString = ' PW1  PW2   L-2 ';
    const result = parseBedString(bedString);
    
    expect(result).toEqual(['PW1', 'PW2', 'L-2']);
  });

  test('handles empty or invalid input', () => {
    expect(parseBedString('')).toEqual([]);
    expect(parseBedString(null as any)).toEqual([]);
    expect(parseBedString(undefined as any)).toEqual([]);
  });
});

describe('upsertItem', () => {
  test('inserts new item when primary key does not exist', () => {
    const items = [
      { recnum: 1, name: 'Item 1' },
      { recnum: 2, name: 'Item 2' }
    ];

    const newItem = { recnum: 3, name: 'Item 3' };
    const result = upsertItem(items, newItem, 'recnum');

    expect(result).toHaveLength(3);
    expect(result[2]).toEqual(newItem);
  });

  test('updates existing item when primary key exists', () => {
    const items = [
      { recnum: 1, name: 'Item 1' },
      { recnum: 2, name: 'Item 2' }
    ];

    const updatedItem = { recnum: 2, name: 'Updated Item 2' };
    const result = upsertItem(items, updatedItem, 'recnum');

    expect(result).toHaveLength(2);
    expect(result[1]).toEqual(updatedItem);
    expect(result[1].name).toBe('Updated Item 2');
  });
});