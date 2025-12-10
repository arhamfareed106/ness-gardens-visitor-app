import { haversineDistance, sortBedsByDistance } from '../distanceCalculations';

// Mock Jest globals for TypeScript
declare var describe: (suiteName: string, callback: () => void) => void;
declare var test: (testName: string, callback: () => void) => void;
declare var expect: (actual: any) => { 
  toBe: (expected: any) => void;
  toEqual: (expected: any) => void;
  toHaveLength: (expected: number) => void;
  toBeCloseTo: (expected: number, precision?: number) => void;
};

describe('haversineDistance', () => {
  test('calculates correct distance between two known points', () => {
    // Distance between Ness Gardens (53.275, -3.041) and Liverpool (53.408, -2.991)
    const distance = haversineDistance(53.275, -3.041, 53.408, -2.991);
    // Expected distance is approximately 15.16 km
    expect(distance).toBeCloseTo(15.16, 1);
  });

  test('returns zero for identical coordinates', () => {
    const distance = haversineDistance(53.275, -3.041, 53.275, -3.041);
    expect(distance).toBe(0);
  });
});

describe('sortBedsByDistance', () => {
  test('sorts beds by distance from user location', () => {
    const beds = [
      { id: '1', name: 'Bed A', latitude: 53.276, longitude: -3.042 },
      { id: '2', name: 'Bed B', latitude: 53.408, longitude: -2.991 },
      { id: '3', name: 'Bed C', latitude: 53.275, longitude: -3.041 }
    ];

    const sortedBeds = sortBedsByDistance(beds, 53.275, -3.041); // User at Ness Gardens

    // Bed C should be first (0 distance), then Bed A, then Bed B
    expect(sortedBeds[0].id).toBe('3');
    expect(sortedBeds[0].distance).toBe(0);
    expect(sortedBeds[1].id).toBe('1');
    expect(sortedBeds[2].id).toBe('2');
  });
});