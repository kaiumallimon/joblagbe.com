<!--image: logo-->
  ![App logo](./assets/logo/logo_org.svg)
# 🚀 Joblagbe.com

A **skill-based job-finding platform** where applicants must pass an **MCQ exam** based on the job they want to apply for. Each applicant gets a **maximum of 2 chances** to pass the MCQ round:
- **First attempt**: Available for all applicants.
- **Second attempt**: Available only if the applicant completes the suggested course for the test.

The **courses** are managed by the **admins** of the **joblagbe.com** site.

## 📊 Dashboards
- **Applicant** (Coming Soon)
- **Recruiter**
- **Admin** (Coming Soon)

## ✨ Features

### 🔹 Role-based Authentication
- Separate dashboards and access for Applicants, Recruiters, and Admins.

### 🔹 Recruiter
- View & explore all available jobs (posted by themselves or others).
- View & explore available courses.
- **Add & manage job posts** (Recruiters must complete their profile before posting a job. If incomplete, they will receive a warning).
- View & manage applications received for job posts.
- Manage their profile.

### 🔹 Applicant (Coming Soon)
- MCQ-based job application process.
- Course completion for second MCQ attempt.
- Profile management.

### 🔹 Admin (Coming Soon)
- Manage courses and job categories.
- Oversee platform activity.

## 🗂️ Project Structure
```
joblagbe.com/
├── assets/
│   ├── fonts/
│   ├── images/
│   ├── logo/
│   ├── lottie/
│   └── svgs/
├── lib/
│   ├── app/
│   │   ├── core/
│   │   │   ├── constants/
│   │   │   ├── theming/
│   │   │   │   ├── colors/
│   │   │   │   └── theme/
│   │   │   ├── utils/
│   │   │   └── widgets/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   └── services/
│   │   ├── modules/
│   │   │   ├── 404/
│   │   │   ├── admin/
│   │   │   ├── applicant/
│   │   │   ├── auth/
│   │   │   ├── forgot_password/
│   │   │   ├── landing/
│   │   │   └── recruiter/
│   │   └── routes/
│   ├── firebase_options.dart
│   └── main.dart
├── test/
├── web/
├── pubspec.yaml
├── pubspec.lock
├── README.md
├── analysis_options.yaml
├── cors.json
├── firebase.json
├── fix-cors.md
└── .gitignore
```

## 🛠️ Technologies Used
| Component           | Technology |
|---------------------|------------|
| **Frontend**        | Flutter    |
| **Backend**         | Firebase   |
| **State Management**| GetX       |
| **Routing**         | Go-Router  |
| **Local Storage**   | Get-Storage|

---

## 🧑‍💻 Author
**Kaium Al Limon**

---

## 📝 License
This project is licensed under the **MIT License**.  