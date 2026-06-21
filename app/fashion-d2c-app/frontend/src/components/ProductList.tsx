import type { Product } from '../types';
import ProductCard from './ProductCard';

interface Props {
  products?: Product[];
  title?: string;
}

export default function ProductList({ products = [], title }: Props) {
  if (!Array.isArray(products)) {
    console.error('ProductList expected products to be Array but got:', products);
    return <p className="text-center py-10 text-gray-500">No products found.</p>;
  }

  if (products.length === 0) return <p className="text-center py-10 text-gray-500">No products found.</p>;

  return (
    <div className="container mx-auto px-4 sm:px-6 lg:px-8 py-12">
      {title && <h2 className="text-3xl font-bold mb-8">{title}</h2>}
      <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
        {products.map((product) => (
          <ProductCard key={product.id} product={product} />
        ))}
      </div>
    </div>
  );
}