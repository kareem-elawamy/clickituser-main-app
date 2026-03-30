# Click It API Documentation

## 🌐 Overview
**Base URL:** `https://clickit.ltd`
**API Status:** 🔴 **Offline / Not Working**
*Note: During testing via cURL, the domain `clickit.ltd` failed to resolve (DNS error). The server is currently unreachable or the domain has expired.*

The application communicates with a backend likely based on the 6valley e-commerce system. Below are the grouped endpoints utilized in the application.

## 📌 Authentication (`/api/v1/auth`)
| Endpoint | Description |
|----------|-------------|
| `/register` | Register a new user |
| `/login` | User login |
| `/logout` | User logout |
| `/forgot-password` | Request password reset |
| `/check-phone` | Send OTP to phone |
| `/verify-phone` | Verify phone OTP |
| `/check-email` | Send OTP to email |
| `/verify-email` | Verify email OTP |
| `/reset-password` | Reset user password |
| `/verify-otp` | Verify general OTP |
| `/social-login` | Login via social media |

## 🛍 Products (`/api/v1/products`)
| Endpoint | Description |
|----------|-------------|
| `/latest` | List latest products |
| `/top-rated` | List top-rated products |
| `/best-sellings` | List best selling products |
| `/discounted-product` | List discounted products |
| `/featured` | List featured products |
| `/home-categories` | List products by home categories |
| `/details/{id}` | Get product details |
| `/reviews/{id}` | Get product reviews |
| `/filter` | Search and filter products |
| `/suggestion-product` | Get product suggestions by name |
| `/related-products/{id}` | Get related products |
| `/most-demanded-product` | List most demanded products |
| `/shop-again-product` | List products to shop again |
| `/just-for-you` | Personalized products |
| `/most-searching` | Most searched products |

## 📂 Categories & Brands
| Endpoint | Description |
|----------|-------------|
| `/api/v1/categories` | List all categories |
| `/api/v1/categories/products/{id}` | Get products by category |
| `/api/v1/categories/find-what-you-need`| Find specific category |
| `/api/v1/brands` | List all brands |
| `/api/v1/brands/products/{id}` | Get products by brand |

## 👤 Customer & Profile (`/api/v1/customer`)
| Endpoint | Description |
|----------|-------------|
| `/info` | Get customer profile info |
| `/update-profile` | Update customer profile |
| `/account-delete` | Delete customer account |
| `/address/list` | List saved addresses |
| `/address/add` | Add a new address |
| `/address/update` | Update an address |
| `/address` | Remove an address |

## 🛒 Cart & Wishlist
| Endpoint | Description |
|----------|-------------|
| `/api/v1/cart` | Get cart data |
| `/api/v1/cart/add` | Add item to cart |
| `/api/v1/cart/update`| Update cart quantity |
| `/api/v1/cart/remove`| Remove item from cart |
| `/api/v1/customer/wish-list` | Get wishlist |
| `/api/v1/customer/wish-list/add` | Add product to wishlist |
| `/api/v1/customer/wish-list/remove`| Remove product from wishlist |

## 📦 Orders & Shipping
| Endpoint | Description |
|----------|-------------|
| `/api/v1/customer/order/list` | Get order history |
| `/api/v1/customer/order/details` | Get order details |
| `/api/v1/customer/order/place` | Place a new order |
| `/api/v1/order/track` | Track an order by ID |
| `/api/v1/order/cancel-order` | Cancel an order |
| `/api/v1/shipping-method/by-seller`| Get shipping methods |
| `/api/v1/shipping-method/choose-for-order`| Select shipping method |

## 💬 Chat & Support
| Endpoint | Description |
|----------|-------------|
| `/api/v1/customer/chat/list/` | List chat conversations |
| `/api/v1/customer/chat/get-messages/`| Get chat messages |
| `/api/v1/customer/chat/send-message/`| Send chat message |
| `/api/v1/customer/support-ticket/create`| Create support ticket |
| `/api/v1/customer/support-ticket/get`| Get support tickets |

## ⚙️ App Config & Utilities
| Endpoint | Description |
|----------|-------------|
| `/api/v1/config` | App configuration and settings |
| `/api/v1/banners` | List banners |
| `/api/v1/notifications`| List notifications |
| `/api/v1/flash-deals` | List flash deals |
| `/api/v1/deals/featured`| Get featured deals |
| `/api/v1/coupon/apply`| Apply coupon code |
