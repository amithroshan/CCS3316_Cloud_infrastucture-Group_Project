const express = require('express');
const path = require('path');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { MongoClient, ServerApiVersion } = require('mongodb');
const { body, validationResult } = require('express-validator');
const app = express();
const port = 3000;

const uri = "mongodb+srv://pasindusahan001:MFUPClMP25UuqFN9@cluster-01.ywwt1.mongodb.net/?retryWrites=true&w=majority&appName=Cluster-01";

const client = new MongoClient(uri, {
  serverApi: {
    version: ServerApiVersion.v1,
    strict: true,
    deprecationErrors: true,
  }
});

app.use(express.static(path.join(__dirname, 'public')));
app.use(express.json()); 

async function getProducts() {
  try {
    await client.connect();
    const database = client.db('ecommerce');
    const productsCollection = database.collection('products');
    const products = await productsCollection.find({}).toArray();
    return products;
  } catch (error) {
    console.error("Error fetching products:", error);
    return [];
  }
}

app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

app.get('/products', async (req, res) => {
  const products = await getProducts();
  if (products.length === 0) {
    res.status(404).send("No products found.");
  } else {
    res.json(products);
  }
});

async function getUsersCollection() {
  const database = client.db('ecommerce');
  return database.collection('users');
}

app.post(
  '/signup',
  body('email').isEmail().normalizeEmail(),
  body('password').isLength({ min: 6 }).withMessage('Password must be at least 6 characters'),
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { email, password } = req.body;

    try {
      const usersCollection = await getUsersCollection();
      const existingUser = await usersCollection.findOne({ email });

      if (existingUser) {
        return res.status(400).json({ message: 'User already exists' });
      }

      const hashedPassword = await bcrypt.hash(password, 10);

      const newUser = { email, password: hashedPassword };
      await usersCollection.insertOne(newUser);

      res.status(201).json({ message: 'User created successfully' });
    } catch (error) {
      console.error('Error signing up user:', error);
      res.status(500).json({ message: 'Internal server error' });
    }
  }
);

app.get('/signup', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'signup.html'));
});


app.post(
  '/login',
  body('email').isEmail().normalizeEmail(),
  body('password').notEmpty().withMessage('Password is required'),
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { email, password } = req.body;

    try {
      const usersCollection = await getUsersCollection();
      const user = await usersCollection.findOne({ email });

      if (!user) {
        return res.status(400).json({ message: 'Invalid email or password' });
      }

      const isMatch = await bcrypt.compare(password, user.password);

      if (!isMatch) {
        return res.status(400).json({ message: 'Invalid email or password' });
      }

      const token = jwt.sign({ userId: user._id, email: user.email }, 'your_jwt_secret', { expiresIn: '1h' });

      res.json({ message: 'Login successful', token });
    } catch (error) {
      console.error('Error logging in user:', error);
      res.status(500).json({ message: 'Internal server error' });
    }
  }
);

app.get('/login', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'login.html'));
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
