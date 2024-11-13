import React from 'react';
import PropTypes from 'prop-types';
import FormattedDate from './FormattedDate';


const CurrentAssignments = ({ assignments }) => {
 if (assignments.length === 0) {
   return <p>No current assignments</p>;
 }


 return (
   <div class="card yellow lighten-5">
     <div class="card-content">
         <span class="card-title">Current Assignments</span>
             <ul>
                 {assignments.map((assignment) => {
                     const { officer, start_date } = assignment.data.attributes;
                     const { first_name, last_name, rank } = officer.data.attributes;
                     return (
                         <li key={assignment.id}>
                             <p>
                                 - {rank} {first_name} {last_name} (as of: {FormattedDate(start_date)})
                             </p>
                         </li>
                     );
                 })}
             </ul>
     </div>
   </div>
   );
}


CurrentAssignments.propTypes = {
 assignments: PropTypes.array.isRequired,
};


export default CurrentAssignments;
