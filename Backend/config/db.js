import mongoose from "mongoose";

const connectDB = async () => {
  try {
    mongoose.set("strictQuery", true); // optional
    const conn = await mongoose.connect(process.env.MONGO_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });

    console.log(
      `MongoDB connected successfully: ${conn.connection.host}, DB: ${conn.connection.name}`
    );
  } catch (error) {
    console.error(`Connection failed: ${error.message}`);
    process.exit(1);
  }
};

export default connectDB;
