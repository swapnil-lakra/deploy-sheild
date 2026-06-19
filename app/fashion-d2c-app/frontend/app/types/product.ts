export interface Product {
  id: number;
  name: string;
  slug: string;
  description: string;
  price: string;             // Chunki backend se price string me aa raha hai ("799.00")
  compare_at_price: string;  // String format ("1299.00")
  category: string;
  image_url: string;
  additional_images: string[] | null; // Null bhi ho sakta hai ya string arrays bhi
  sizes: string[];           // Array of sizes like ["S", "M", "L"]
  colors: string[];          // Array of colors like ["White", "Black"]
  inventory_count: number;
  is_active: boolean;
  is_featured: boolean;
  badge: string | null;      // Agar kisi product me badge na ho toh null handle ho sake
  created_at: string;        // ISO Date string format
  updated_at: string;        // ISO Date string format
}