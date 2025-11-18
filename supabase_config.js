// Supabase Configuration File
// This file contains configuration for connecting to Supabase
// Replace the placeholder values with your actual Supabase project credentials

// Get these values from: Supabase Dashboard > Settings > API

const supabaseConfig = {
  // Your Supabase project URL
  // Format: https://[project-ref].supabase.co
  url: process.env.SUPABASE_URL || 'YOUR_SUPABASE_URL',
  
  // Your Supabase anon/public key
  // This key is safe to use in client-side code
  anonKey: process.env.SUPABASE_ANON_KEY || 'YOUR_SUPABASE_ANON_KEY',
  
  // Your Supabase service role key (server-side only!)
  // NEVER expose this in client-side code
  serviceRoleKey: process.env.SUPABASE_SERVICE_ROLE_KEY || 'YOUR_SUPABASE_SERVICE_ROLE_KEY',
};

// Example: Initialize Supabase client (for Node.js)
// Install: npm install @supabase/supabase-js

/*
const { createClient } = require('@supabase/supabase-js');

// For client-side usage (browser)
const supabase = createClient(
  supabaseConfig.url,
  supabaseConfig.anonKey
);

// For server-side usage (Node.js)
const supabaseAdmin = createClient(
  supabaseConfig.url,
  supabaseConfig.serviceRoleKey,
  {
    auth: {
      autoRefreshToken: false,
      persistSession: false
    }
  }
);
*/

// Example: Database connection string (for direct PostgreSQL connections)
// Format: postgresql://postgres:[PASSWORD]@db.[PROJECT-REF].supabase.co:5432/postgres
const databaseConnectionString = process.env.DATABASE_URL || 
  'postgresql://postgres:[YOUR-PASSWORD]@db.[PROJECT-REF].supabase.co:5432/postgres';

module.exports = {
  supabaseConfig,
  databaseConnectionString,
};

// Example usage in your application:
/*
// 1. Set up environment variables (.env file):
// SUPABASE_URL=https://your-project.supabase.co
// SUPABASE_ANON_KEY=your-anon-key
// SUPABASE_SERVICE_ROLE_KEY=your-service-role-key

// 2. Import and use:
const { supabaseConfig } = require('./supabase_config');
const { createClient } = require('@supabase/supabase-js');

const supabase = createClient(
  supabaseConfig.url,
  supabaseConfig.anonKey
);

// 3. Query your database:
async function getProducts() {
  const { data, error } = await supabase
    .from('products')
    .select('*')
    .eq('is_active', true);
  
  if (error) {
    console.error('Error:', error);
    return null;
  }
  
  return data;
}

// 4. Run custom SQL queries:
async function getCustomerInsights() {
  const { data, error } = await supabase.rpc('get_customer_insights');
  
  if (error) {
    console.error('Error:', error);
    return null;
  }
  
  return data;
}
*/


