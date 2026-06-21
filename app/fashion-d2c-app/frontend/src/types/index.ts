export interface Product {
  id: number;
  name: string;
  slug: string;
  description: string | null;
  price: number;
  compare_at_price: number | null;
  category: string | null;
  image_url: string | null;
  additional_images: string[] | null;
  sizes: string[] | null;
  colors: string[] | null;
  inventory_count: number;
  is_active: boolean;
  is_featured: boolean;
  badge: string | null;
  created_at: string;
  updated_at: string;
}