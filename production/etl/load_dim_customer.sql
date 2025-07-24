-- Load DimCustomer (idempotent)
INSERT INTO DimCustomer (UserID, FirstName, LastName, Email, PhoneNumber, RoleName, CreatedAt)
SELECT DISTINCT
    u.UserID, u.FirstName, u.LastName, u.Email, u.PhoneNumber, r.RoleName, u.CreatedAt
FROM Users u
LEFT JOIN Roles r ON u.RoleID = r.RoleID
ON CONFLICT (UserID) DO NOTHING; 