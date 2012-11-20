## -*- coding: utf-8 -*-
<?xml version="1.0" encoding="UTF-8"?>
<!-- Copyright (C) 2012 The Android Open Source Project

     Licensed under the Apache License, Version 2.0 (the "License");
     you may not use this file except in compliance with the License.
     You may obtain a copy of the License at

          http://www.apache.org/licenses/LICENSE-2.0

     Unless required by applicable law or agreed to in writing, software
     distributed under the License is distributed on an "AS IS" BASIS,
     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
     See the License for the specific language governing permissions and
     limitations under the License.
-->
<metadata
    xmlns="http://schemas.android.com/service/camera/metadata/"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://schemas.android.com/service/camera/metadata/ metadata_properties.xsd">

<tags>
% for tag in metadata.tags:
  <tag id="${tag.id}"><!-- TODO: fill the tag description --></tag>
% endfor
</tags>

% for root in metadata.outer_namespaces:
<namespace name="${root.name}">
  % for section in root.sections:
  <section name="${section.name}">

    % if section.description is not None:
      <description>${section.description}</description>
    % endif

    % for kind in section.kinds: # dynamic,static,controls
      <${kind.name}>

        <%def name="insert_body(node)">
            % for nested in node.namespaces:
                ${insert_namespace(nested)}
            % endfor

            % for entry in node.entries:
                ${insert_entry(entry)}
            % endfor
        </%def>

        <%def name="insert_namespace(namespace)">
        <namespace name="${namespace.name}">
            ${insert_body(namespace)}
        </namespace>
        </%def>

        <%def name="insert_entry(prop)">
        % if prop.is_clone():
            <clone entry="${prop.name}" kind="${prop.target_kind}">

              % if prop.notes is not None:
                <notes>${prop.notes}</notes>
              % endif

              % for tag in prop.tags:
                <tag id="${tag.id}" />
              % endfor

            </clone>
        % else:
            <entry name="${prop.name_short}" type="${prop.type}"
          % if prop.type_notes is not None:
                type_notes="${prop.type_notes}"
          % endif
          % if prop.container is not None:
                container="${prop.container}"
          % endif
            >

              % if prop.container == 'array':
                <array>
                  % for size in prop.container_sizes:
                    <size>${size}</size>
                  % endfor
                </array>
              % elif prop.container == 'tuple':
                <tuple>
                  % for size in prop.container_sizes:
                    <value /> <!-- intentionally generated empty. manually fix -->
                  % endfor
                </tuple>
              % endif
              % if prop.type == 'enum':
                <enum>
                  % for value in prop.enum.values:
                      <value
                    % if value.optional:
                             optional="true"
                    % endif:
                    % if value.id is not None:
                             id="${value.id}"
                    % endif
                      >${value.name}
                    % if value.notes is not None:
                             <notes>${value.notes}</notes>
                    % endif
                      </value>
                  % endfor
                </enum>
              % endif

              % if prop.description is not None:
                <description>${prop.description | x}</description>
              % endif

              % if prop.units is not None:
                <units>${prop.units | x}</units>
              % endif

              % if prop.range is not None:
                <range>${prop.range | x}</range>
              % endif

              % if prop.notes is not None:
                <notes>${prop.notes | x}</notes>
              % endif

              % for tag in prop.tags:
                <tag id="${tag.id}" />
              % endfor

            </entry>
        % endif
        </%def>

        ${insert_body(kind)}

      </${kind.name}>
    % endfor # for each kind

  </section>
  % endfor
</namespace>
% endfor

</metadata>