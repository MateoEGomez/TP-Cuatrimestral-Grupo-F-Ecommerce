using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace dominio
{
    public class FormaEntrega
    {
        public int Id { get; set; }
        public string Descripcion { get; set; }
        public bool RequiereDireccion { get; set; }
        public bool Activo { get; set; }

        public override string ToString()
        {
            return Descripcion;
        }
    }
}
