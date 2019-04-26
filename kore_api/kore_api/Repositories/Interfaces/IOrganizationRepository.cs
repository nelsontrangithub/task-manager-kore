using kore_api.koredb;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace kore_api.Repositories.Interfaces
{
    public interface IOrganizationRepository
    {
        IEnumerable<Organization> GetOrganizations();
    }
}
