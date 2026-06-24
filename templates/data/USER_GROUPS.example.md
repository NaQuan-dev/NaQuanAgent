# USER_GROUPS.example

This is a user-to-groups view template. Real users, groups, departments, and notes must stay in a private workspace and must not be committed to the framework repository.

The user view helps determine which group messages a requester may query in a private conversation. It can be generated from the real relationship-detail file corresponding to `GROUP_MEMBERSHIPS.example.csv`.

| user_id | display_name | department | status | chat_refs | verified_at | notes |
| --- | --- | --- | --- | --- | --- | --- |
| `<USER_ID>` | `<DISPLAY_NAME>` | `<DEPARTMENT>` | active | `<CHAT_REF_1>;<CHAT_REF_2>` | `<YYYY-MM-DD>` | `<NOTES>` |
