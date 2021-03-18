local claims = std.extVar('claims');
{
  identity: {
    traits: {
      // Allowing unverified email addresses enables account
      // enumeration attacks, especially if the value is used for
      // e.g. verification or as a password login identifier.
      //
      // If connecting only to your organization (one tenant), claims.email is safe to use if you have not actively disabled e-mail verification during signup.
      //
      // The email might be empty if the account is not linked to an email address.
      // For a human readable identifier, consider using the "preferred_username" claim.
      [if "email" in claims then "email" else null]: claims.email,
    },
  },
}