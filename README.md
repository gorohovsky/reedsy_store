# Project Overview

This project was developed as a response to an evaluation task from Reedsy: [Reedsy Challenge](ruby-on-rails-engineer-v2.md)

## Prerequisites

- Ruby 3.3.5
- Bundler 2.5.21
- MySQL (MariaDB 10.3.38 in my case)

## Deployment

1. Run `bundle install`
2. Set the following environment variables in the `.env` file or in the environment itself:

   **Database credentials:**
   ```bash
   RS_DB_USER
   RS_DB_PASS
   ```

   The three mentioned in the task products will be seeded, but if you want to populate the discounts as well, set the following variable:
   ```bash
   SEED_DISCOUNTS=true
   ```

3. **Database Setup**
   If the specified database user is different from "root", create it in the database console and/or grant permissions for the project's databases. Example:

   ```sql
   CREATE USER 'user'@'localhost' IDENTIFIED BY 'password';
   GRANT ALL PRIVILEGES ON reedsy_store_dev.* TO 'user'@'localhost' IDENTIFIED BY 'password';
   GRANT ALL PRIVILEGES ON reedsy_store_test.* TO 'user'@'localhost' IDENTIFIED BY 'password';
   ```
   (Replace 'user' and 'password' everywhere with the values from the above-mentioned environment variables)

   Then run:

   ```bash
   rails db:setup
   ```

Now you should be all set to run the Rails server with `rails s` or use RSpec.

## cURL Samples

### Products API

- **Get all products:**
  ```bash
  curl --location 'localhost:3000/products/' \
  --header 'Accept: application/json'
  ```

- **Update a product:**
  ```bash
  curl --location --globoff --request PUT 'localhost:3000/products/1?product[price]=1570' \
  --header 'Accept: application/json'
  ```

### Discounts API

- **Get all discounts for a product:**
  ```bash
  curl --location 'localhost:3000/products/1/discounts' \
  --header 'Accept: application/json'
  ```

- **Get specific discount info:**
  ```bash
  curl --location 'localhost:3000/products/1/discounts/2' \
  --header 'Accept: application/json'
  ```

- **Create a new discount:**
  ```bash
  curl --location --globoff --request POST 'localhost:3000/products/1/discounts?discount[rate]=0.4&discount[min_product_count]=200' \
  --header 'Accept: application/json'
  ```

- **Update a discount:**
  ```bash
  curl --location --globoff --request PUT 'http://localhost:3000/products/1/discounts/17?discount[min_product_count]=250&discount[rate]=0.5' \
  --header 'Accept: application/json'
  ```

- **Delete a discount:**
  ```bash
  curl --location --request DELETE 'http://localhost:3000/products/1/discounts/17' \
  --header 'Accept: application/json'
  ```

### Cart API

- **Get a total price for specified products' quantities with discounts (if any):**
  ```bash
  curl --location --globoff 'http://localhost:3000/check_price?products[hoodie]=10&products[mug]=6&products[tshirt]=150' \
  --header 'Accept: application/json'
  ```
  