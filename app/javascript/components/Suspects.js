import React from "react";
import PropTypes from "prop-types";
import Select from "react-select";
import { get, put, post } from "../api";
import FormattedDate from "./FormattedDate";

function SuspectEditor({ close, onSave }) {
  const [options, setOptions] = React.useState([]);
  const [suspectId, setSuspectId] = React.useState();

  React.useEffect(() => {
    get(`/v1/criminals`).then((response) => {
      setOptions(
        response.criminals.map((criminal) => {
          return {
            value: criminal.data.id,
            label: `${criminal.data.attributes.first_name} ${criminal.data.attributes.last_name}`
          };
        })
      );
    });
  }, []);

  return (
    <>
      <Select
        options={options}
        onChange={({ value }) => setSuspectId(value)}
      />
      <button onClick={() => onSave(suspectId)} disabled={!suspectId}>
        Save
      </button>{" "}
      <button onClick={close}>Cancel</button>
    </>
  );
}

SuspectEditor.propTypes = {
  close: PropTypes.func.isRequired,
  onSave: PropTypes.func.isRequired,
  currentSuspects: PropTypes.arrayOf(PropTypes.object).isRequired,
};

function Suspects({ suspects, investigationId }) {
  const [editorOpen, setEditorOpen] = React.useState(false);
  const [currentSuspects, setCurrentSuspects] = React.useState(suspects);

  function onSave(suspectId) {
    post(`/v1/investigations/${investigationId}/suspects`, {
      suspect: {
        criminal_id: suspectId,
      },
    }).then((response) => {
      setCurrentSuspects([response].concat(currentSuspects));
      setEditorOpen(false);
    });
  }

  const handleDropSuspect = (suspectId) => {
    put(`/v1/drop_suspect/${suspectId}`, {
        suspect: {
        dropped_on: new Date(),
      },
    }).then(() => {
      setCurrentSuspects(
        currentSuspects.map((suspect) => {
          if (suspect.data.id === suspectId) {
            return {
              ...suspect,
              data: {
                ...suspect.data,
                attributes: {
                  ...suspect.data.attributes,
                  dropped_on: new Date(),
                },
              },
            };
          }
          return suspect;
        })
      );
    }).catch((error) => console.error("Error dropping suspect:", error));
    };

  const content =
    currentSuspects.length === 0 ? (
      <p>This investigation does not have any suspects associated with it.</p >
    ) : (
      <ul>
        {currentSuspects.map((suspect) => {
          const { criminal, added_on, dropped_on } = suspect.data.attributes;
          const { first_name, last_name } = criminal.data.attributes;
          return (
            <li key={`suspect-${suspect.data.id}`}>
              <p>
                {first_name} {last_name} 
                <br/>
                - Added: {FormattedDate(added_on)} 
                <br/>
                - Dropped: {dropped_on ? FormattedDate(dropped_on) : 'N/A'}
              </p >
              {!dropped_on && (
                <button onClick={() => handleDropSuspect(suspect.data.id)}>Drop</button>
              )}
            </li>
          );
        })}
      </ul>
    );

  return (
    <>
      <div class="card yellow lighten-5">
        <div class="card-content">
          <span class="card-title">Suspects</span>
            {content}
            {editorOpen && (
              <SuspectEditor
                close={() => setEditorOpen(false)}
                onSave={onSave}
                currentSuspects={currentSuspects}
              />
            )}
            {!editorOpen && <button onClick={() => setEditorOpen(true)}>Add</button>}

        </div>
      </div>
    </>
  );
}

Suspects.propTypes = {
    suspects: PropTypes.arrayOf(PropTypes.object).isRequired,
    investigationId: PropTypes.string.isRequired,
  };
  
export default Suspects;