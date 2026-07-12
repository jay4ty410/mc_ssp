# mc_ssp

A Flutter application for Smart Scheduler with Firebase Authentication, Cloud Firestore, Firebase Storage, and Firebase Cloud Messaging.

## Firestore architecture

The app uses a user-scoped Firestore structure under `users/{userId}` with dedicated collections for profile, settings, statistics, tasks, reminders, notes, events, subjects, study sessions, and generated timetables.

### Security rules

Firebase security rules are defined in [firestore.rules](firestore.rules). They enforce that each user can only read or write their own data.

### Firestore indexes

Composite indexes for task, reminder, event, note, subject, study session, and timetable queries are defined in [firestore.indexes.json](firestore.indexes.json).

### Best practices applied

- Use Firestore timestamps instead of strings for dates.
- Keep each document focused and small.
- Store user-owned data under the authenticated user's UID.
- Use subcollections for entity types rather than one giant user document.
- Keep the daily schedule as a derived view assembled from tasks, reminders, events, and study sessions rather than duplicating it in a separate collection.
- Use server timestamps for created/updated metadata.
