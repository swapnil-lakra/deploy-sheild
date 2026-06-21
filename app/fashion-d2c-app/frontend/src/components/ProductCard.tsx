import { Link } from 'react-router-dom';
import type { Product } from '../types';

interface Props {
  product: Product;
}

export default function ProductCard({ product }: Props) {
  return (
    <Link to={`/product/${product.id}`} className="group block">
      <div className="relative overflow-hidden rounded-2xl bg-white shadow-sm hover:shadow-xl transition duration-300">
        {product.badge && (
          <span className="absolute top-3 left-3 z-10 bg-white/90 backdrop-blur text-xs font-semibold px-2.5 py-1 rounded-full shadow-md">
            {product.badge}
          </span>
        )}
        <div className="aspect-3/4 overflow-hidden bg-gray-100">
          <img
            src={product.image_url || 'https://via.placeholder.com/400x500?text=No+Image'}
            alt={product.name}
            className="w-full h-full object-cover group-hover:scale-105 transition duration-500"
          />
        </div>
        <div className="p-4">
          <p className="text-xs text-gray-500 uppercase tracking-wider">{product.category}</p>
          <h3 className="text-lg font-semibold mt-1 truncate">{product.name}</h3>
          <div className="flex items-center gap-2 mt-2">
            <span className="text-xl font-bold">₹{product.price}</span>
            {product.compare_at_price && (
              <span className="text-sm line-through text-gray-400">₹{product.compare_at_price}</span>
            )}
          </div>
        </div>
      </div>
    </Link>
  );
}