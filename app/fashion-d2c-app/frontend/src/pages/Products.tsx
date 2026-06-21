import { useEffect, useState } from 'react';
import { productAPI } from '../api';
import type { Product } from '../types';
import ProductList from '../components/ProductList';

export default function Products() {
  const [products, setProducts] = useState<Product[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    productAPI.getAll({ limit: 20 })
      .then(setProducts)
      .finally(() => setLoading(false));
  }, []);

  if (loading) return <div className="p-12 text-center">Loading products...</div>;
  return <ProductList products={products} title="All Products" />;
}