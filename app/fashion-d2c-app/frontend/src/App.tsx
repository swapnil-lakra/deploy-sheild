import { BrowserRouter, Routes, Route } from 'react-router-dom';
import Header from "../src/components/Header";
import Home from "../src/pages/Home";
import Products from "../src/pages/Products";
import ProductDetail from "../src/pages/ProductDetail";

function App() {
  return (
    <BrowserRouter>
      <Header />
      <main>
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/products" element={<Products />} />
          <Route path="/product/:id" element={<ProductDetail />} />
        </Routes>
      </main>
    </BrowserRouter>
  );
}

export default App;