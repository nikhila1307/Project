import college from "../model/collegeModel.js";

export const createCollege = async (req, res) => {
  try {
    const { name, code, email, phone, address, features } = req.body;

    // check for existing college
    const existingCollege = await college.findOne({
      $or: [{ code }, { email }],
    });
    if (existingCollege) {
      return res
        .status(400)
        .json({ message: "College with this code or email already exists" });
    }

    const defaultFeatures = {
      feeManagement: true,
      examModule: true,
      hostelManagement: false,
      library: false,
      attendance: true,
    };

    const college = await college.create({
      name,
      code,
      email,
      phone,
      address,
      features: features || defaultFeatures,
    });

    return res.status(201).json(college);
  } catch (error) {
    console.error(err);
    return res
      .status(500)
      .json({ message: "Server error", error: err.message });
  }
};
