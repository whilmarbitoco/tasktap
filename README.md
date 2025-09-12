# 📱 TaskTap – On-Demand Micro-Task App

## 📝 Overview

TaskTap is a mobile app that connects **people who need small tasks done** with **local helpers** (students, freelancers, part-timers) who can complete them quickly.  
Think of it as a **localized TaskRabbit** for Tagum City — built for everyday needs like grocery runs, fixing appliances, deliveries, tutoring, or pet walking.

---

## 🎯 Problem

- People are **busy or lack skills** for certain chores and errands.
- There is **no centralized and trusted platform** in Tagum City for finding quick, reliable help.
- Freelancers and students have free time but **limited access to small income opportunities**.

---

## 💡 Solution

TaskTap provides a **real-time, community-driven marketplace**:

- **Requesters**: Post a task, set budget & deadline.
- **Helpers**: View available tasks nearby, accept, and complete them for payment.
- **Trust & Safety**: Ratings, reviews, and in-app payments.
- **Instant Matching**: Push notifications to helpers in the area.

---

## 💰 Business Model

- **Commission per task** (e.g., ₱50–₱100 service fee).
- **Premium helper membership** with perks (priority listing, verified badge).
- **B2B Partnerships**: Local stores and businesses can post delivery or service tasks.

---

## 🌍 Why Tagum City?

- Population: ~300,000+ (2020 Census).
- Growing **urbanization and smartphone penetration**.
- Strong **community culture** makes it easier to build trust.
- Lower market competition compared to major cities — ideal for piloting.

---

## 📊 Market Opportunity (TAM/SAM/SOM – Tagum City)

| Market Stage | Households/Users | Tasks per Year | Potential Revenue (₱) |
| ------------ | ---------------- | -------------- | --------------------- |
| **TAM**      | ~12,850          | 154,200        | ~7,708,800            |
| **SAM**      | ~6,400           | 77,100         | ~3,854,400            |
| **SOM**      | ~640             | 7,700          | ~385,200              |

_(Assumptions: 60% smartphone penetration, 30% adoption rate, ₱50 revenue per task, 12 tasks/year per user.)_

---

## 🚀 Impact

- **For users:** Convenience, time savings, reliable help on-demand.
- **For helpers:** Extra income opportunities for students, freelancers, and part-timers.
- **For community:** Builds a stronger local economy by keeping services within Tagum.

---

## 🔮 Future Plans

- Expand to other cities in Davao Region.
- Add secure e-wallet & payment integrations.
- Introduce task categories (household, tutoring, deliveries, events).
- Launch a **SkillSwap mode** for barter-style exchanges.

## Folder Structure

A common structure is to separate UI, data, and business logic:

    lib/
    ├─ models/        # Data classes, JSON parsing (User, Product, etc.)
    ├─ services/      # API, database, or platform services
    ├─ repositories/  # Combines multiple services, applies business rules
    ├─ viewmodels/    # State management (MVVM "VM" part)
    ├─ views/         # UI widgets/screens
    └─ widgets/       # Reusable UI components (buttons, text fields, etc.)

28
