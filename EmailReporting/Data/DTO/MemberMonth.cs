namespace EmailReporting.Data.DTO
{
    internal class MemberMonth
    {
        public string YearMonth { get; set; }
        public string MemberName { get; set; }

        public bool IsFuture { get; set; }
        public bool IsActive { get; set; }
    }
}
