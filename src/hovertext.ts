interface ReferenceEntry {
  type: "instruction" | "register" | "directive" | "alias";
}

interface InstructionEntry extends ReferenceEntry {
  mnemonic: string;
  instruction: string;
  operation: string;
  assemblerSyntax: string;
  example: string;
  description: string;
  usage?: string;
}

interface RegisterEntry extends ReferenceEntry {
  name: string;
  function: string;
}

interface DirectiveEntry extends ReferenceEntry {
  name: string;
  description: string;
  usage: string;
}

interface AliasEntry extends ReferenceEntry {
  alias: string;
}

type ReferenceData = { [mnemonic: string]: ReferenceEntry };

function uppercaseFirst(text: string): string {
  return text.charAt(0).toUpperCase() + text.slice(1);
}

function formatInstruction(instruction: InstructionEntry): string {
  let text = `
**${uppercaseFirst(instruction.instruction)}**

**Operation:** ${instruction.operation}

**Syntax:**
\`\`\`niosii
${instruction.assemblerSyntax}
\`\`\`

**Example:**
\`\`\`niosii
${instruction.example}
\`\`\`

**Description:**

${uppercaseFirst(instruction.description)}
  `;

  if (instruction.usage !== undefined) {
    text += `
**Usage:**

${uppercaseFirst(instruction.usage)}
`;
  }

  return text;
}

function formatRegister(register: RegisterEntry): string {
  let text = `
**${register.name}**

${register.function}
`;
  return text;
}

function formatDirective(directive: DirectiveEntry): string {
  let text = `
**${directive.usage}**

${directive.description}
`;
  return text;
}

export function hoverText(
  referenceData: ReferenceData,
  word: string
): string | null {
  if (word.length > 32) {
    return null;
  }

  if (!(word in referenceData)) {
    return null;
  }

  const reference = referenceData[word];

  switch (reference.type) {
    case "instruction":
      return formatInstruction(reference as InstructionEntry);
    case "register":
      return formatRegister(reference as RegisterEntry);
    case "directive":
      return formatDirective(reference as DirectiveEntry);
    case "alias":
      return hoverText(referenceData, (reference as AliasEntry).alias);
    default:
      console.warn("Unsupported reference type:", reference.type);
      return null;
  }
}
