import Dexie, { type Table } from 'dexie';
import type { Cable, Circuit, Save } from '@/../../shared/schema';

// IndexedDB Database
class SpliceDB extends Dexie {
  cables!: Table<Cable>;
  circuits!: Table<Circuit>;
  saves!: Table<Save>;

  constructor(dbName: string) {
    super(dbName);
    this.version(2).stores({
      cables: 'id, name, type',
      circuits: 'id, cableId, position, isSpliced',
      saves: 'id, createdAt'
    });
  }
}

// Separate databases for fiber and copper modes
export const fiberDb = new SpliceDB('FiberSpliceDB');
export const copperDb = new SpliceDB('CopperSpliceDB');

// Get database instance based on mode
export function getDb(mode: 'fiber' | 'copper') {
  return mode === 'fiber' ? fiberDb : copperDb;
}

// Legacy export for backward compatibility (defaults to fiber)
export const db = fiberDb;
