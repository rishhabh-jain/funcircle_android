-- Query to verify community guidelines data exists
SELECT
    policy_type,
    title,
    version,
    effective_date,
    LEFT(content, 100) as content_preview,
    created_at
FROM public.app_policies
WHERE policy_type = 'community';

-- If the above returns no rows, check all policies:
SELECT
    policy_type,
    title,
    version
FROM public.app_policies
ORDER BY created_at DESC;
