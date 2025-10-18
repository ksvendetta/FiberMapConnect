# Fiber Optic Cable Splicing Management Application

## Overview

This application is a professional fiber optic cable splicing management tool designed for managing circuits within fiber cables. It provides a simple checkbox-based system for marking circuits as spliced. The system enables users to create cables with specific fiber counts, define circuit IDs with auto-calculated fiber positions, and track which circuits have been spliced using checkboxes.

## User Preferences

Preferred communication style: Simple, everyday language.

## System Architecture

### Frontend Architecture

**Framework & Build System**
- React 18 with TypeScript for type-safe component development
- Vite as the build tool and development server for fast hot module replacement
- Wouter for lightweight client-side routing (only Home and NotFound pages)

**State Management & Data Fetching**
- TanStack Query (React Query) for server state management with automatic caching and synchronization
- React Hook Form with Zod validation for form state management and validation
- Query client configured with infinite stale time and disabled automatic refetching for stable data scenarios

**UI Component System**
- Shadcn UI component library (New York style variant) with Radix UI primitives
- Tailwind CSS with custom HSL-based color system for theming
- Material Design principles adapted for technical/industrial use case
- Custom fiber color visualization system matching industry-standard fiber optic color codes (12 colors: blue, orange, green, brown, slate, white, red, black, yellow, violet, pink, aqua)

**Design System Highlights**
- Dark mode as primary interface with deep navy-charcoal backgrounds (220 15% 10%)
- Professional blue primary color (220 90% 56%)
- Exact HSL color specifications for fiber optic standard colors
- Typography: Inter for UI, JetBrains Mono for technical data (cable IDs, fiber numbers)
- Responsive spacing using Tailwind's scale (2, 4, 6, 8, 12, 16, 20)

### Backend Architecture

**Server Framework**
- Express.js with TypeScript for RESTful API endpoints
- HTTP server created via Node's built-in http module
- Custom middleware for request logging with response capture
- Error handling middleware for centralized error responses

**API Design**
- RESTful endpoints under `/api` prefix
- CRUD operations for cables: GET /api/cables, GET /api/cables/:id, POST /api/cables, PUT /api/cables/:id, DELETE /api/cables/:id
- Circuit operations: GET /api/circuits, GET /api/circuits/cable/:cableId, POST /api/circuits/:id/toggle-spliced, DELETE /api/circuits/:id
- Toggle splice status: POST /api/circuits/:id/toggle-spliced - Toggles the isSpliced boolean field for a circuit
- Request validation using Zod schemas derived from Drizzle ORM schema definitions
- JSON request/response format with appropriate HTTP status codes

**Development & Production Modes**
- Development: Vite middleware integration for hot module replacement
- Production: Static file serving from dist/public directory
- Conditional Replit-specific plugins for development features

### Data Storage Solutions

**ORM & Schema Management**
- Drizzle ORM for type-safe database operations with PostgreSQL dialect
- Schema-first approach with Drizzle-Zod integration for automatic validation schema generation
- Database schema defined in shared/schema.ts for full-stack type sharing

**Database Schema**
- **Cables Table**: Stores cable definitions with id (UUID), name, fiberCount, ribbonSize (always 12, not exposed in UI), and type (restricted to "Feed" or "Distribution")
- **Circuits Table**: Stores circuit ID assignments and fiber allocations within each cable (cableId, circuitId, position, fiberStart, fiberEnd - all auto-calculated, isSpliced - integer 0/1)
- UUID primary keys using PostgreSQL's gen_random_uuid()
- Integer-based boolean for isSpliced field (0/1) for database compatibility

**Storage Abstraction**
- IStorage interface defining all data operations for cables and circuits
- DatabaseStorage class implementing PostgreSQL-backed persistent storage via Drizzle ORM
- Cascade deletion support (deleting a cable removes associated circuits)
- toggleCircuitSpliced method for updating isSpliced boolean field

### External Dependencies

**Database**
- PostgreSQL (via Neon serverless driver @neondatabase/serverless)
- Drizzle Kit for schema migrations (output to ./migrations directory)
- Connection via DATABASE_URL environment variable (required)

**Core Libraries**
- React ecosystem: react, react-dom, wouter (routing)
- State management: @tanstack/react-query, react-hook-form
- Validation: zod, @hookform/resolvers
- UI components: Full Radix UI suite (@radix-ui/react-*)
- Styling: tailwindcss, class-variance-authority, clsx, tailwind-merge
- Date handling: date-fns
- Utilities: nanoid (ID generation), cmdk (command palette)

**Development Tools**
- TypeScript with strict mode enabled
- ESBuild for production server bundling
- Replit-specific plugins: vite-plugin-runtime-error-modal, vite-plugin-cartographer, vite-plugin-dev-banner
- PostCSS with Tailwind and Autoprefixer

**Build & Deployment**
- npm scripts: dev (tsx with NODE_ENV=development), build (Vite + ESBuild bundling), start (production node server), db:push (sync schema to database)
- Client built to dist/public, server bundled to dist/index.js
- Path aliases: @/ for client/src, @shared/ for shared, @assets/ for attached_assets
- Module resolution: ESNext with bundler mode for modern import syntax

## Key Features (Updated October 2025)

### Database Persistence
- Full PostgreSQL database integration via Neon serverless driver
- All cables and circuits persist across sessions
- Automatic schema migrations with Drizzle Kit
- UUID-based primary keys for all records

### Checkbox-Based Splicing System
- Simple checkbox interface to mark circuits as "spliced"
- Each circuit in CircuitManagement component has a "Spliced" checkbox
- Clicking checkbox toggles the isSpliced boolean field (0/1)
- Splice tab displays all circuits where isSpliced === 1
- Real-time updates when toggling splice status

### Cable Search
- **Cable Search**: Real-time search by cable name or type
- Instant UI updates using React useMemo for performance
- No-results states for better user experience

### Circuit ID Management (Auto-Calculated Fiber Positions)
- **Simplified Input**: Circuit ID is the ONLY required input (e.g., "lg,33-36", "b,1-2")
- **Auto-Calculation**: Fiber positions automatically calculated based on circuit order in the list
  - Circuit order determines ribbon placement
  - First circuit starts at fiber 1, subsequent circuits follow sequentially
  - Example: "lg,33-36" as 6th circuit → auto-assigned to R2: 9-12
- **Smart Recalculation**: Deleting a circuit automatically recalculates positions for all remaining circuits
- **Ribbon Display**: Shows exact ribbon and fiber positions (e.g., "R1: 1-2" or "R1: 5-12 and R2: 1-2" for spanning circuits)
- **Real-time Validation**: Pass/Fail indicator shows if circuits total exactly matches cable fiber count
- **Visual Feedback**: Shows assigned/total fiber count (e.g., "24 / 24 fibers")
- **Automatic Persistence**: All circuit data persists across sessions

### User Interface
- Two main tabs: **InputData** (for managing cables and circuits) and **Splice** (for viewing spliced circuits)
- InputData tab: Cable list with search, cable details, and circuit management
- Splice tab: Table showing all circuits marked as spliced (cable name, circuit ID, fiber range)
- Responsive design with professional technical interface

## Recent Changes (October 18, 2025)
- **Major Simplification - Checkbox-Based Splicing**:
  - Replaced complex splice entity system with simple checkbox-based approach
  - Removed splice tables, forms, connections visualization, and related components
  - Added isSpliced boolean field to circuits table
  - Implemented POST /api/circuits/:id/toggle-spliced endpoint for toggling splice status
  - Updated CircuitManagement component to show checkboxes for marking circuits as spliced
  - Simplified Splice tab to display table of circuits where isSpliced === 1
  - Removed ribbon size details from circuit display (now shows only fiber ranges)
- **Auto-Calculated Circuit Management**:
  - Circuit ID as sole input (fiber positions calculated from order)
  - Automatic fiber range calculation based on circuit sequence
  - Smart recalculation when circuits are deleted
  - Pass/fail validation for complete fiber allocation
- **Integrated Cable and Circuit Creation**:
  - Circuits entered during cable creation via multi-line textarea
  - Backend creates cable and associated circuits in one transaction
  - Auto-validates that circuits don't exceed cable fiber capacity
- **Simplified Cable Configuration**:
  - Ribbon size always defaults to 12 (not exposed in UI)
  - Cable type restricted to "Feed" and "Distribution" only
  - Database persistence with PostgreSQL
  - Cable search functionality by name or type