// models/User.js
import mongoose from "mongoose";
import bcrypt from "bcryptjs";

const userSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
      trim: true,
      index: true,
    },
    email: {
      type: String,
      required: true,
      lowercase: true,
      trim: true,
      unique: true,
      match: [/^[^\s@]+@[^\s@]+\.[^\s@]+$/, "Invalid email"],
      index: true,
    },
    password: {
      type: String,
      required: true,
      select: false, // hide by default
    },
    role: {
      type: String,
      enum: ["superadmin", "college_admin", "staff", "student", "parent"],
      required: true,
    },
    college: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "college",
      required: function () {
        return this.role !== "superadmin"; // superadmin not linked to any college
      },
    },
    staffRole: {
      type: String, // e.g., teacher, librarian, accountant
    },
    staffPermissions: {
      type: [String], // optional finer permissions for staff
      default: [],
    },
    studentProfile: {
      rollNo: String,
      course: String,
      year: Number,
    },
    parentOf: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User", // references student IDs
      },
    ],
    isActive: {
      type: Boolean,
      default: true,
    },
    deletedAt: {
      type: Date,
      default: null,
      select: false,
    },
  },
  { timestamps: true }
);

// ------------------------
// Password hashing
userSchema.pre("save", async function (next) {
  if (!this.isModified("password")) return next();
  const salt = await bcrypt.genSalt(10);
  this.password = await bcrypt.hash(this.password, salt);
  next();
});

// ------------------------
// Instance method to compare password
userSchema.methods.matchPassword = async function (enteredPassword) {
  return bcrypt.compare(enteredPassword, this.password);
};

export default mongoose.model("User", userSchema);
