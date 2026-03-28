// routes/collegeRoutes.js
import express from "express";
import { createCollege } from "../controllers/collegecontroller.js";
import { authorizeRoles } from "../middlewares/collegeMiddleware.js";

const router = express.Router();

// Only superadmin can create a college
// router.post("/college", authorizeRoles("superadmin"), createCollege);

export default router;
