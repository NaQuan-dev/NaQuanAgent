# CHAT_GROUPS.example

This is a group registry template. Real group names, external platform identifiers, membership relationships, and notes must stay in a private workspace and must not be committed to the framework repository.

The group view helps answer which active members are currently in a group. It can be generated from the real relationship-detail file corresponding to `GROUP_MEMBERSHIPS.example.csv`.

| chat_ref | display_name | status | private_query_enabled | member_user_ids | membership_source | verified_at | notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `<CHAT_REF>` | `<GROUP_DISPLAY_NAME>` | active | true | `<USER_ID_1>;<USER_ID_2>` | `<CONNECTOR_NAME>` | `<YYYY-MM-DD>` | `<NOTES>` |
