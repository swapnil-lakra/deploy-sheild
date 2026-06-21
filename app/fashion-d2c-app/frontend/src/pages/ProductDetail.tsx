import { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';
import { productAPI } from '../api';
import type { Product } from '../types';

export default function ProductDetail() {
  const { id } = useParams<{ id: string }>();
  const [product, setProduct] = useState<Product | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    if (!id) return;
    productAPI.getById(Number(id))
      .then(setProduct)
      .catch((err) => setError(err.message))
      .finally(() => setLoading(false));
  }, [id]);

  if (loading) return <div className="p-12 text-center">Loading...</div>;
  if (error) return <div className="p-12 text-center text-red-500">{error}</div>;
  if (!product) return <div className="p-12 text-center">Product not found</div>;

  return (
    <div className="container mx-auto px-4 py-12 max-w-6xl">
      <div className="grid grid-cols-1 md:grid-cols-2 gap-12">
        <div className="aspect-3/4 overflow-hidden rounded-2xl bg-gray-100">
          <img src={product.image_url || ''} alt={product.name} className="w-full h-full object-cover" />
        </div>
        <div>
          <p className="text-sm text-gray-500 uppercase tracking-wider">{product.category}</p>
          <h1 className="text-4xl font-bold mt-2">{product.name}</h1>
          <div className="flex items-center gap-3 mt-4">
            <span className="text-3xl font-bold">₹{product.price}</span>
            {product.compare_at_price && (
              <span className="text-xl line-through text-gray-400">₹{product.compare_at_price}</span>
            )}
          </div>
          <p className="mt-6 text-gray-700 leading-relaxed">{product.description}</p>
          <div className="mt-8 space-y-4">
            <div>
              <h4 className="font-semibold">Sizes</h4>
              <div className="flex flex-wrap gap-2 mt-2">
                {product.sizes?.map((s) => (
                  <span key={s} className="border border-gray-300 rounded-full px-4 py-1 text-sm hover:border-black cursor-pointer transition">
                    {s}
                  </span>
                ))}
              </div>
            </div>
            <div>
              <h4 className="font-semibold">Colors</h4>
              <div className="flex flex-wrap gap-2 mt-2">
                {product.colors?.map((c) => (
                  <span key={c} className="border border-gray-300 rounded-full px-4 py-1 text-sm hover:border-black cursor-pointer transition">
                    {c}
                  </span>
                ))}
              </div>
            </div>
          </div>
          <button className="mt-10 w-full bg-black text-white py-4 rounded-full text-lg font-semibold hover:bg-gray-800 transition shadow-md">
            Add to Cart
          </button>
        </div>
      </div>
    </div>
  );
}