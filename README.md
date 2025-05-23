# Mini TaskHub - Personal Task Tracker
A beautiful Flutter task management app with Supabase backend.


<p align="center">
  <img src="https://github.com/user-attachments/assets/ffbe7dd1-2bb9-45f2-ae51-b2465b658d9f" width="250" />
  <img src="https://github.com/user-attachments/assets/29e80cad-97ea-44ab-b895-1b7cd7e9b129" width="250" />
  <img src="https://github.com/user-attachments/assets/f5c386e9-3881-4b2e-be96-a39541ee3452" width="250" />
  <img src="https://github.com/user-attachments/assets/aafac0d9-3ccf-4072-a45c-560b24eab975" width="250" />
</p>




## Features
- ✅ User authentication (Login/Signup)
- 📝 Create, read, update, and delete tasks
- 🗂️ Filter tasks by status (All/Pending/Completed)
- 🎨 Dark theme with amber accents
- 🔄 Real-time sync with Supabase

## Prerequisites
- Flutter SDK (v3.0.0 or higher)
- Dart (v2.17.0 or higher)
- Supabase account

## Installation

1. Clone the repository:
```bash
git clone https://github.com/ThisIsSumit/mini_task-hub.git
cd mini_taskhub
```

2. Install dependencies:
```bash
flutter pub get
```

3. Create `.env` file in root directory:
```env
SUPABASE_URL=your_project_url
SUPABASE_ANON_KEY=your_anon_key
```

## Supabase Setup

1. Create new project at [supabase.com](https://supabase.com)
2. Enable Email/Password auth:
   - Go to Authentication → Providers → Enable "Email"
3. Create `tasks` table in SQL Editor:
```sql
CREATE TABLE tasks (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id uuid REFERENCES auth.users ON DELETE CASCADE,
  title text,
  status text DEFAULT 'pending',
  created_at timestamp DEFAULT now()
);
```

4. Enable Row Level Security:
```sql
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can manage their tasks" ON tasks
  FOR ALL USING (auth.uid() = user_id);
```

## Running the App
```bash
flutter run
```

## Development Tips

### Hot Reload vs Hot Restart
| Feature        | Hot Reload (Ctrl+\) | Hot Restart (Ctrl+Shift+\) |
|---------------|--------------------|--------------------------|
| Speed         | Fast (1-2s)        | Slow (10-15s)           |
| State         | Preserved          | Reset                   |
| Best for      | UI changes        | Auth/routing changes   |

## Dependencies
- [supabase_flutter](https://pub.dev/packages/supabase_flutter) - Backend integration
- [provider](https://pub.dev/packages/provider) - State management
- [flutter_slidable](https://pub.dev/packages/flutter_slidable) - Swipe actions
- [intl](https://pub.dev/packages/intl) - Date formatting

## Demo
https://youtu.be/MLcN8VOfit8

- Complete Supabase setup guide
- Development tips specific to this project
- Clean dependency listing
- Space for your demo video
- Proper markdown formatting for easy copying
