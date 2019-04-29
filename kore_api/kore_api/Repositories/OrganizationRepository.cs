using kore_api.koredb;
using kore_api.Repositories.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace kore_api.Repositories
{
    public class OrganizationRepository : IOrganizationRepository
    {
        private readonly koredbContext _context;

        public OrganizationRepository(koredbContext context)
        {
            _context = context;
        }

        public IEnumerable<Organization> GetOrganizations()
        {
            return _context.Organization;
        }
    }
}