# AI-Driven Job Order System with Analytics and Recommendation Features  
**for Galit Digital Printing Services**

---

## 📌 Project Description
Galit Digital Printing Services in Lobo, Batangas processes around 2,000 orders monthly, offering services such as tarpaulin printing, custom apparel, signage, event giveaways, billboards, and sintraboard.

Currently, the shop relies on handwritten logs and outdated spreadsheets, leading to inefficiencies, delays, and customer dissatisfaction.

This project introduces an **AI-driven, web-based Job Order Management System prototype** designed for **admin-only access**. It includes:
- **Simulated job order tracking**  
- **Inventory and records overview**  
- **Dashboard analytics with AI-powered recommendation placeholders**  
- **Dark mode feature** for a modern and user-friendly interface  

As a **UI prototype**, the system does not include backend or database integration — it uses **static JSON data for demonstration purposes.**

---

## 🎯 Problem Statement
The current manual process makes it hard to track job orders, inventory, and records accurately. Misplaced instructions and inefficient updates often result in delays and dissatisfied customers.

The prototype addresses these issues by providing:

- A **centralized admin dashboard** for job orders, records, and inventory management.  
- **Real-time (simulated)** job status and inventory tracking.  
- **Analytics and AI placeholders** for future decision-making.  
- **Dark mode interface** to reduce eye strain and improve usability.

---

## ✅ Objectives
- Create an **admin-only job order management interface.**  
- Provide an **interactive dashboard prototype** for job tracking, records, and analytics.  
- Add an **inventory monitoring module** with stock alerts (simulation).  
- Implement **dark mode UI.**  
- Ensure **responsive design** for various screen sizes.  
- Prepare a **foundation for AI-powered recommendations** in future phases.

---

## 🛠️ Development Model
- **Methodology:** Agile Unified Process (AUP)  
- **Approach:** Iterative UI prototyping with stakeholder feedback  
- **Tech Stack:**  
  - **Frontend:** Flutter, Dart 
  - **Data:** Static JSON (for mock job orders, inventory, and records)  
  - **Design Tools:** Figma, VS Code  

---

## 👤 User Role
**Admin Only**
- Add, update, and view job orders (UI-only).  
- Track pending and completed jobs.  
- Monitor **inventory levels** and manage records.  
- View job queues, dashboards, and analytics.  
- Toggle **dark mode** for better user experience.  
- Access **AI analytics placeholders.**

---

## 🔐 Functional Requirements
| **Role** | **Requirement** |
|----------|-----------------|
| Admin    | Create and manage job orders (front-end only) |
| Admin    | Monitor job order status, inventory, and records |
| Admin    | View dashboard analytics and AI placeholders |
| Admin    | Use dark mode for improved UI |
| Admin    | Navigate through a responsive, user-friendly interface |

---

## 📲 Features Summary
- **📦 Job Order Creation and Management (Prototype UI)**  
- **📊 Dashboard Analytics (Static Data)**  
- **📋 Inventory & Records Overview (Simulation)**  
- **🖥️ Responsive Layout Design**  
- **🌙 Dark Mode Feature**  
- **🔍 Job Status Tracking (No backend)**  

---

## 🧪 User Acceptance Testing (UAT)

### **UAT Environment**

| **Item**          | **Description**                 |
|-------------------|---------------------------------|
| Device            | Android Phone / Emulator        |
| OS Version        | Android 12+                     |
| App Version       | 1.0.0                           |
| Development Tool  | Flutter                         |
| Framework         | Flutter SDK 3.x                 |
| Testing Method    | Manual User Testing             |


### **Completed Test Cases**

| **Test Case ID** | **Scenario**                  | **Expected Result**                                      | **Actual Result**                                            | **Status** |
|------------------|--------------------------------|----------------------------------------------------------|--------------------------------------------------------------|------------|
| UAT-01           | Admin Login                    | Admin is successfully redirected to the dashboard.       | Admin successfully logged in and dashboard displayed.        | ✅ Passed  |
| UAT-02           | Manage Job Order               | Job order is correctly returned and displayed in job order list. | Job order saved and appeared correctly in the job list.       | ✅ Passed  |
| UAT-03           | Update Job Status              | Job status updates are reflected in real time on the dashboard. | Job status updated and displayed in real time.               | ✅ Passed  |
| UAT-04           | Inventory Management           | Inventory changes are saved and updated correctly.       | Inventory adjustments saved and reflected accurately.        | ✅ Passed  |
| UAT-05           | Manage Payments                | Payment records are correctly filtered or displayed according to search criteria. | Payment transactions filtered or displayed accurately according to search criteria. | ✅ Passed  |
| UAT-06           | Analytics Charts Interactivity | Charts display interactive elements and respond appropriately to interactions. | Charts interactive, accurate data tooltips on hover and click.| ✅ Passed  |
| UAT-07           | Reports Charts Interactivity   | Reports charts interactively display detailed data upon user interactions. | Report charts respond correctly to interactions and display correct details. | ✅ Passed  |
| UAT-08           | Responsive Layout              | Layout adapts smoothly and displays correctly across different screen sizes and devices. | Layout properly adapts and displayed correctly on tested devices and screen sizes. | ✅ Passed  |
| UAT-09           | View Notifications             | Notifications are viewable by Admin without errors.      | Admin successfully viewed notifications.                     | ✅ Passed  |
| UAT-10           | Sidebar Navigation             | Sidebar navigation links correctly redirect to appropriate system pages without errors. | Sidebar navigation fully functional, all links redirect correctly. | ✅ Passed  |
| UAT-11           | Admin Logout                   | Admin successfully logs out and returns to the login page.| Admin successfully logged out and redirected to login page.   | ✅ Passed  |


-
