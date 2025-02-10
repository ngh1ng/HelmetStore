CREATE DATABASE helmet_store;
USE helmet_store;

-- Users
CREATE TABLE users (
    id INT PRIMARY KEY IDENTITY(1,1),
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(50) NOT NULL,
	address VARCHAR(1000) NOT NULL,
    role VARCHAR(20) CHECK (role IN ('user', 'manager', 'admin')) DEFAULT 'user',  -- 3 main role --
    is_active BIT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE()
);

-- Brands 
CREATE TABLE brands (
    id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(50) UNIQUE NOT NULL
);

-- Styles (Fullface/Modular/Open Face)
CREATE TABLE styles (
    id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(20) UNIQUE NOT NULL
);

-- Size (S/M/L/XL)
CREATE TABLE size (
    id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(20) UNIQUE NOT NULL
);

-- Helmet Models
CREATE TABLE helmet_models (
    id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(100) NOT NULL,
    brand_id INT NOT NULL,
    style_id INT NOT NULL,
	size_id INT NOT NULL,
	purchase_price DECIMAL(10,2) NOT NULL,
    selling_price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (brand_id) REFERENCES brands(id) ON DELETE CASCADE,
    FOREIGN KEY (style_id) REFERENCES styles(id) ON DELETE CASCADE,
	FOREIGN KEY (size_id) REFERENCES size(id) ON DELETE CASCADE
);

-- Wishlist
CREATE TABLE wishlist (
    id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    model_id INT NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (model_id) REFERENCES helmet_models(id) ON DELETE CASCADE
);

-- Orders (Manager)
CREATE TABLE orders (
    id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) CHECK (status IN ('pending', 'processing', 'shipped', 'delivered', 'canceled')) DEFAULT 'pending',
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Order Detail (Manager)
CREATE TABLE order_items (
    id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT NOT NULL,
    model_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (model_id) REFERENCES helmet_models(id) ON DELETE CASCADE
);

-- Store_Statistics (Admin)
CREATE TABLE store_statistics (
    id INT PRIMARY KEY IDENTITY(1,1),
    report_date DATE UNIQUE NOT NULL,	--filter by day --
    total_revenue DECIMAL(15,2) DEFAULT 0,
    total_products_sold INT DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE()
);

-- Inventory_Logs (Inport/Export Product Log - Manager)
CREATE TABLE inventory_logs (
    id INT PRIMARY KEY IDENTITY(1,1),
    model_id INT NOT NULL,
    action VARCHAR(10) CHECK (action IN ('import', 'sell', 'return')) NOT NULL,
    quantity INT NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
	FOREIGN KEY (model_id) REFERENCES helmet_models(id) ON DELETE CASCADE
);
