import mongoose from "mongoose";
import slugify from "slugify"

const collegeSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
      trim: true,
      index: true,
    },
    slug: {
    type: String,
    index: true,
    unique: true,
    select: false // optional: only include when needed
  },
    email: {
      type: String,
      required: true,
      lowercase: true,
      trim: true,
      match: [/^[^\s@]+@[^\s@]+\.[^\s@]+$/, "Invalid email"],
      index: true,
    },
    phone: { type: String, required: true },
    code: {
      type: String,
      unique: true,
      required: true,
      minlength: 2,
      maxlength: 20,
    },
    address: {
      line1: { type: String, trim: true },
      line2: { type: String, trim: true },
      city: { type: String, trim: true, index: true },
      state: { type: String, trim: true, index: true },
      country: { type: String, trim: true, default: "India" },
      pincode: {
        type: String,
        trim: true
      },
    },
    features: { 
        type: Map, 
        of: Boolean, 
        default: {} 
    },
    isActive: { 
        type: Boolean, 
        default: true 
    },
    deletedAt: { 
        type: Date, 
        default: null, 
        select: false },
  },
  { timestamps: true }
);




// Pre-save hook: create slug from name if not provided
collegeSchema.pre("save", function (next) {
  if (this.isModified("name")) {
    this.slug = slugify(this.name, { lower: true, strict: true }).slice(0, 100);
  }
  next();
});

/**
 * Function: 
 * Description: Get all colleges that are not deleted
 * @param {college}  
 * @returns {college} 
 */
collegeSchema.pre(/^find/, function(next) {
  this.where({ deletedAt: null }); // only find active colleges
  next();
});


const college = mongoose.model("college", collegeSchema);
export default college;
