# members.example

This is a group member cache template. Real members, external platform identifiers, and notes must stay in a private workspace and must not be committed to the framework repository.

## Group Info

| Field | Value |
| --- | --- |
| Group name | `<GROUP_DISPLAY_NAME>` |
| chat_ref | `<CHAT_REF>` |
| Sync source | `<CONNECTOR_NAME>` |
| member_id_type | `<MEMBER_ID_TYPE>` |
| Last verified at | `<YYYY-MM-DDTHH:MM:SS+08:00>` |
| Member count | `<COUNT>` |

## Members

| display_name | user_id | member_ref | status | notes |
| --- | --- | --- | --- | --- |
| `<DISPLAY_NAME>` | `<USER_ID>` | `<MEMBER_REF>` | active | `<NOTES>` |

## Private Query Rules

- This file records the group-to-user view for one group. The user-to-group view should be generated from membership details.
- Member status can be used for quick checks, but it is not the only permission source. High-risk or conflicting cases require trusted real-time verification.
- For new members, removed members, or identity conflicts, do not grant access by name or nickname. Use stable identity and trusted connector results.
